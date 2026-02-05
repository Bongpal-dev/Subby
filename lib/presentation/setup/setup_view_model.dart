import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';

/// 셋업 화면 단계
enum SetupStep {
  loading,
  cloudSync,
  nickname,
  completed,
}

class SetupState {
  final SetupStep step;
  final bool isProcessing;

  const SetupState({
    this.step = SetupStep.loading,
    this.isProcessing = false,
  });

  SetupState copyWith({
    SetupStep? step,
    bool? isProcessing,
  }) {
    return SetupState(
      step: step ?? this.step,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class SetupViewModel extends FamilyNotifier<SetupState, bool> {
  @override
  SetupState build(bool nicknameOnly) {
    Future.microtask(() {
      if (nicknameOnly) {
        state = state.copyWith(step: SetupStep.nickname);
      } else {
        state = state.copyWith(step: SetupStep.cloudSync);
      }
    });
    return const SetupState();
  }

  /// 로그인 다이얼로그 후 처리 (Google 로그인 여부 확인 후 다음 단계 결정)
  Future<void> handleAfterLoginDialog() async {
    print('[Setup] handleAfterLoginDialog called');
    // UseCase를 통해 현재 인증 상태 확인
    final checkAuthState = ref.read(checkAuthStateUseCaseProvider);
    final authState = checkAuthState();
    print('[Setup] isAnonymous: ${authState.isAnonymous}, userId: ${authState.userId}');

    if (authState.isAnonymous) {
      state = state.copyWith(step: SetupStep.nickname);
      return;
    }

    state = state.copyWith(isProcessing: true);

    final fetchUserInfoUseCase = ref.read(fetchUserInfoUseCaseProvider);
    final hasNickname = await fetchUserInfoUseCase();

    if (hasNickname) {
      ref.invalidate(currentNicknameStateProvider);
      await _completeSetup();
    } else {
      state = state.copyWith(step: SetupStep.nickname, isProcessing: false);
    }
  }

  /// 익명 로그인 수행 → 닉네임 단계로 이동
  Future<void> signInAnonymously() async {
    state = state.copyWith(isProcessing: true);
    final signInAnonymouslyUseCase = ref.read(signInAnonymouslyUseCaseProvider);
    await signInAnonymouslyUseCase();
    state = state.copyWith(step: SetupStep.nickname, isProcessing: false);
  }

  /// 닉네임 설정 완료
  Future<void> handleNicknameSet(String nickname) async {
    state = state.copyWith(isProcessing: true);

    final saveUserInfoUseCase = ref.read(saveUserInfoUseCaseProvider);
    await saveUserInfoUseCase(nickname: nickname);

    ref.invalidate(currentNicknameStateProvider);
    await _completeSetup();
  }

  /// 셋업 완료 처리
  Future<void> _completeSetup() async {
    await ref.read(setupCompletedProvider.notifier).completeSetup();
    state = state.copyWith(step: SetupStep.completed, isProcessing: false);
  }
}

final setupViewModelProvider =
    NotifierProvider.family<SetupViewModel, SetupState, bool>(SetupViewModel.new);

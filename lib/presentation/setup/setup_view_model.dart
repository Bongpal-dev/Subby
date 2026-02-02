import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/data/datasource_providers.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
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

class SetupViewModel extends Notifier<SetupState> {
  @override
  SetupState build() {
    Future.microtask(() {
      state = state.copyWith(step: SetupStep.cloudSync);
    });
    return const SetupState();
  }

  /// 로그인 다이얼로그 후 처리 (Google 로그인 여부 확인 후 다음 단계 결정)
  Future<void> handleAfterLoginDialog() async {
    final isAnonymous = await ref.read(isAnonymousProvider.future);
    final didGoogleLogin = !isAnonymous;
    await handleCloudSyncResult(didGoogleLogin);
  }

  /// 클라우드 연동 선택 처리 (로그인 or 익명)
  /// [didGoogleLogin] Google 로그인 성공 여부
  Future<void> handleCloudSyncResult(bool didGoogleLogin) async {
    if (!didGoogleLogin) {
      // 익명 로그인 → 닉네임 설정 필요
      state = state.copyWith(step: SetupStep.nickname);
      return;
    }

    // Google 로그인 → 기존 닉네임 확인
    state = state.copyWith(isProcessing: true);

    ref.invalidate(currentNicknameProvider);
    final existingNickname = await ref.read(currentNicknameProvider.future);
    final hasNickname = existingNickname != null && existingNickname.isNotEmpty;

    if (hasNickname) {
      // 닉네임 있음 → 스킵
      await _completeSetup();
    } else {
      // 닉네임 없음 → 설정 필요
      state = state.copyWith(step: SetupStep.nickname, isProcessing: false);
    }
  }

  /// 익명 로그인 수행
  Future<void> signInAnonymously() async {
    state = state.copyWith(isProcessing: true);
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signInAnonymously();
    state = state.copyWith(isProcessing: false);
  }

  /// 닉네임 설정 완료
  Future<void> handleNicknameSet(String nickname) async {
    state = state.copyWith(isProcessing: true);

    // 닉네임 저장
    final nicknameLocalDataSource = ref.read(nicknameLocalDataSourceProvider);
    await nicknameLocalDataSource.saveNickname(nickname);
    ref.invalidate(currentNicknameProvider);

    await _completeSetup();
  }

  /// 셋업 완료 처리
  Future<void> _completeSetup() async {
    await ref.read(setupCompletedProvider.notifier).completeSetup();
    state = state.copyWith(step: SetupStep.completed, isProcessing: false);
  }
}

final setupViewModelProvider =
    NotifierProvider<SetupViewModel, SetupState>(SetupViewModel.new);

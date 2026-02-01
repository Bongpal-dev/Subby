import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/utils/nickname_generator.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_dialog.dart';
import 'package:subby/presentation/common/widgets/subby_text_input_dialog.dart';
import 'package:subby/presentation/common/widgets/subby_tooltip.dart';

/// 온보딩 흐름 핸들러
/// 신규 사용자: 툴팁 → 닉네임 설정 → 클라우드 연동
/// 기존 사용자: 닉네임 설정 (클라우드 연동은 이미 됨)
class OnboardingFlowHandler {
  final BuildContext context;
  final WidgetRef ref;
  final GlobalKey? fabKey;
  final GlobalKey? summaryCardKey;
  final GlobalKey? drawerKey;

  OnboardingFlowHandler({
    required this.context,
    required this.ref,
    this.fabKey,
    this.summaryCardKey,
    this.drawerKey,
  });

  /// 온보딩 흐름 시작
  Future<void> startOnboardingFlow() async {
    final onboardingType = ref.read(onboardingTypeProvider);
    final coachMarkCompleted = ref.read(coachMarkCompletedProvider);
    final nicknameSet = ref.read(nicknameSetProvider);
    final cloudSyncPrompted = ref.read(cloudSyncPromptedProvider);

    // 신규 사용자이고 코치마크 미완료 시 툴팁 표시
    if (onboardingType == OnboardingType.newUser && !coachMarkCompleted) {
      await _showCoachMarks();
    }

    // 닉네임 미설정 시 다이얼로그 표시
    if (!nicknameSet) {
      await _showNicknameDialog();
    }

    // 클라우드 연동 미제안 시 (익명 로그인한 경우) 다이얼로그 표시
    if (!cloudSyncPrompted && onboardingType == OnboardingType.newUser) {
      await _showCloudSyncDialog();
    }
  }

  /// 코치마크(툴팁) 표시
  Future<void> _showCoachMarks() async {
    if (!context.mounted) return;

    // 1. 구독 추가 툴팁 (FAB 버튼)
    if (fabKey != null) {
      await showCoachMark(
        context: context,
        title: '구독 추가하기',
        description: '+버튼을 눌러 구독중인 서비스를 추가하세요',
        targetKey: fabKey!,
        tooltipPosition: TooltipPosition.top,
      );
    }

    if (!context.mounted) return;

    // 2. 예상 구독료 툴팁 (Summary Card)
    if (summaryCardKey != null) {
      await showCoachMark(
        context: context,
        title: '예상 구독료 확인하기',
        description: '이번 달 총 예상 구독료를 확인하세요',
        targetKey: summaryCardKey!,
        tooltipPosition: TooltipPosition.bottom,
      );
    }

    if (!context.mounted) return;

    // 3. 그룹 관리 툴팁 (Drawer)
    if (drawerKey != null) {
      await showCoachMark(
        context: context,
        title: '그룹으로 함께 관리',
        description: '그룹을 만들고 가족·친구와 공유하세요',
        targetKey: drawerKey!,
        tooltipPosition: TooltipPosition.right,
      );
    }

    // 코치마크 완료 저장
    await ref.read(coachMarkCompletedProvider.notifier).completeCoachMark();
  }

  /// 닉네임 설정 다이얼로그
  Future<void> _showNicknameDialog() async {
    if (!context.mounted) return;

    final colors = context.colors;

    final nickname = await showSubbyTextInputDialog(
      context: context,
      title: '닉네임 설정',
      description: '다른 사람에게 보일 이름을\n입력해 주세요',
      hint: '닉네임을 입력하세요',
      initialValue: NicknameGenerator.generate(),
      cancelLabel: '취소',
      confirmLabel: '변경하기',
      barrierDismissible: false,
      suffixIcon: SvgPicture.asset(
        'assets/icons/ic_refresh_small.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          colors.iconSecondary,
          BlendMode.srcIn,
        ),
      ),
      onGenerateValue: NicknameGenerator.generate,
    );

    if (nickname != null && nickname.isNotEmpty) {
      // TODO: 닉네임 저장 (NicknameRepository 사용)
      await ref.read(nicknameSetProvider.notifier).completeNicknameSet();
    } else {
      // 취소해도 완료 처리 (다시 묻지 않음)
      await ref.read(nicknameSetProvider.notifier).completeNicknameSet();
    }
  }

  /// 클라우드 연동 다이얼로그
  Future<void> _showCloudSyncDialog() async {
    if (!context.mounted) return;

    final colors = context.colors;

    await showSubbyDialog(
      context: context,
      iconType: AppIconType.download,
      iconColor: colors.statusInfo,
      title: '클라우드에 연동할까요?',
      description: '로그인하면 데이터가 안전하게 저장되고,\n다른 기기에서도 사용할 수 있어요',
      barrierDismissible: false,
      actions: [
        SubbyDialogAction(
          label: '나중에',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SubbyDialogAction(
          label: '로그인',
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context);
            await _handleGoogleLogin();
          },
        ),
      ],
    );

    // 클라우드 연동 제안 완료 저장
    await ref.read(cloudSyncPromptedProvider.notifier).completeCloudSyncPrompt();
  }

  /// Google 로그인 처리
  Future<void> _handleGoogleLogin() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithGoogle();

    if (result is GoogleSignInSuccess) {
      // 로그인 성공 - 기존 데이터 마이그레이션 필요할 수 있음
    }
    // 취소하거나 실패해도 다시 묻지 않음 (cloudSyncPrompted = true)
  }

}

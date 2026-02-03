import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subby/core/router/app_router.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';

/// 온보딩 화면
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<void> _handleNewUser() async {
    await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();

    if (mounted) {
      context.go(AppRoutes.onboardingTutorial);
    }
  }

  Future<void> _handleReturningUser() async {
    await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();

    if (mounted) {
      context.go(AppRoutes.setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // 콘텐츠 영역 (중앙 정렬)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 로고
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.bgAccent,
                        borderRadius: BorderRadius.circular(AppSpacing.s4),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/icons/subby_place_holder.svg',
                        colorFilter: ColorFilter.mode(
                          colors.textOnAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    // 제목
                    Text(
                      'Subby에 오신 걸 환영해요!',
                      style: AppTypography.title.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    // 부제목
                    Text(
                      'Subby를 처음 사용하시나요?',
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 버튼 영역
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.s4,
                right: AppSpacing.s4,
                top: AppSpacing.s6,
                bottom: AppSpacing.s10,
              ),
              child: Column(
                children: [
                  // 처음이에요 버튼 (신규 사용자)
                  SubbyButton(
                    label: '처음이에요',
                    type: SubbyButtonType.primary,
                    isExpanded: true,
                    onPressed: _handleNewUser,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  // 써본 적 있어요 버튼 (기존 사용자)
                  SubbyButton(
                    label: '써본 적 있어요',
                    type: SubbyButtonType.text,
                    isExpanded: true,
                    onPressed: _handleReturningUser,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';

/// 온보딩 화면
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _handleAnonymousLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInAnonymously();
      await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: '로그인에 실패했습니다. 다시 시도해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signInWithGoogle();

      switch (result) {
        case GoogleSignInSuccess():
          await ref
              .read(onboardingCompletedProvider.notifier)
              .completeOnboarding();
        case GoogleSignInCancelled():
          // 사용자가 취소함 - 온보딩 화면 유지
          break;
        case GoogleSignInError():
          if (mounted) {
            Fluttertoast.showToast(
              msg: 'Google 로그인에 실패했습니다. 다시 시도해주세요.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Google 로그인에 실패했습니다. 다시 시도해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.bgAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'S',
                        style: AppTypography.title.copyWith(
                          color: colors.textOnAccent,
                          fontWeight: FontWeight.bold,
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
                  // 처음이에요 버튼 (익명 로그인)
                  SubbyButton(
                    label: '처음이에요',
                    type: SubbyButtonType.primary,
                    isExpanded: true,
                    isEnabled: !_isLoading,
                    onPressed: _handleAnonymousLogin,
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  // 써본 적 있어요 버튼 (Google 로그인)
                  SubbyButton(
                    label: '써본 적 있어요',
                    type: SubbyButtonType.text,
                    isExpanded: true,
                    isEnabled: !_isLoading,
                    onPressed: _handleGoogleLogin,
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

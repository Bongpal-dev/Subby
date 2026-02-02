import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/utils/nickname_generator.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_dialog.dart';
import 'package:subby/presentation/common/widgets/subby_text_input_dialog.dart';

/// 온보딩 설정 화면
/// 코치마크 완료 후 환영 화면 표시 → 닉네임 설정 → 클라우드 연동 처리
class OnboardingSetupScreen extends ConsumerStatefulWidget {
  const OnboardingSetupScreen({super.key});

  @override
  ConsumerState<OnboardingSetupScreen> createState() =>
      _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState extends ConsumerState<OnboardingSetupScreen> {
  bool _isLoading = false;
  String _loadingMessage = '';

  @override
  void initState() {
    super.initState();
    // 화면이 빌드된 후 다이얼로그 흐름 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSetupFlow();
    });
  }

  Future<void> _startSetupFlow() async {
    // 1. 닉네임 다이얼로그
    await _showNicknameDialog();

    // 2. 클라우드 연동 다이얼로그
    final wantsGoogleLogin = await _showCloudSyncDialog();

    // 3. 로딩 화면 전환
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingMessage = wantsGoogleLogin ? 'Google 로그인 중...' : '준비 중...';
      });
    }

    // 4. 로그인 처리
    if (wantsGoogleLogin) {
      await _handleGoogleLogin();
    } else {
      await _handleAnonymousLogin();
    }

    // 5. 완료 → 홈으로 이동
    if (mounted) {
      await ref
          .read(cloudSyncPromptedProvider.notifier)
          .completeCloudSyncPrompt();
    }
  }

  Future<void> _showNicknameDialog() async {
    if (!mounted) return;

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
    }
    // 닉네임 설정 완료 (취소해도 완료 처리)
    await ref.read(nicknameSetProvider.notifier).completeNicknameSet();
  }

  /// 클라우드 연동 다이얼로그
  /// 반환값: true = Google 로그인 선택, false = 나중에 선택
  Future<bool> _showCloudSyncDialog() async {
    if (!mounted) return false;

    final colors = context.colors;
    bool wantsGoogleLogin = false;

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
            wantsGoogleLogin = false;
            Navigator.pop(context);
          },
        ),
        SubbyDialogAction(
          label: '로그인',
          isPrimary: true,
          onPressed: () {
            wantsGoogleLogin = true;
            Navigator.pop(context);
          },
        ),
      ],
    );

    return wantsGoogleLogin;
  }

  Future<void> _handleGoogleLogin() async {
    if (!mounted) return;

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithGoogle();

    if (result is GoogleSignInSuccess) {
      if (mounted) {
        setState(() {
          _loadingMessage = '준비 중...';
        });
      }
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      // 취소하거나 실패하면 익명 로그인
      await _handleAnonymousLogin();
    }
  }

  Future<void> _handleAnonymousLogin() async {
    if (!mounted) return;

    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signInAnonymously();

    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colors.bgAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loadingMessage,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

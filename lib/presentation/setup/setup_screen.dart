import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subby/core/router/app_router.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/utils/nickname_generator.dart';
import 'package:subby/presentation/common/widgets/subby_dialog.dart';
import 'package:subby/presentation/common/widgets/subby_text_input_dialog.dart';
import 'package:subby/presentation/common/app_drawer.dart';
import 'package:subby/presentation/setup/setup_view_model.dart';

class SetupScreen extends ConsumerStatefulWidget {
  final bool nicknameOnly;

  const SetupScreen({super.key, this.nicknameOnly = false});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setupViewModelProvider(widget.nicknameOnly));
    final colors = context.colors;

    // Step 변경 시 UI 반응
    ref.listen<SetupStep>(
      setupViewModelProvider(widget.nicknameOnly).select((s) => s.step),
      (previous, next) {
        if (previous == next) return;
        _handleStepChange(next);
      },
    );

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Text(
                '설정 중...',
                style: AppTypography.title.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (state.isProcessing) ...[
                const SizedBox(height: AppSpacing.s4),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleStepChange(SetupStep step) {
    switch (step) {
      case SetupStep.loading:
        break;
      case SetupStep.cloudSync:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showCloudSyncDialog();
        });
      case SetupStep.nickname:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNicknameDialog();
        });
      case SetupStep.completed:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.home);
        });
    }
  }

  Future<void> _showCloudSyncDialog() async {
    if (!mounted) return;

    final colors = context.colors;
    final vm = ref.read(setupViewModelProvider(widget.nicknameOnly).notifier);

    final wantsLogin = await showSubbyDialog<bool>(
      context: context,
      iconType: AppIconType.download,
      iconColor: colors.statusInfo,
      title: '클라우드에 연동할까요?',
      description: '로그인하면 데이터가 안전하게 저장되고,\n다른 기기에서도 사용할 수 있어요',
      barrierDismissible: false,
      actions: [
        SubbyDialogAction(
          label: '나중에',
          onPressed: () => Navigator.pop(context, false),
        ),
        SubbyDialogAction(
          label: '로그인',
          isPrimary: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (!mounted) return;

    print('[Setup] wantsLogin: $wantsLogin');
    if (wantsLogin == true) {
      await showLoginDialog(context: context, ref: ref);
      print('[Setup] showLoginDialog returned, mounted: $mounted');
      if (!mounted) return;
      print('[Setup] calling handleAfterLoginDialog');
      await vm.handleAfterLoginDialog();
      print('[Setup] handleAfterLoginDialog completed');
    } else {
      await vm.signInAnonymously();
    }
  }

  Future<void> _showNicknameDialog() async {
    if (!mounted) return;

    final colors = context.colors;
    final vm = ref.read(setupViewModelProvider(widget.nicknameOnly).notifier);

    final nickname = await showSubbyTextInputDialog(
      context: context,
      title: '닉네임 설정',
      description: '다른 사람에게 보일 이름을\n입력해 주세요',
      hint: '닉네임을 입력하세요',
      initialValue: NicknameGenerator.generate(),
      confirmLabel: '확인하기',
      barrierDismissible: false,
      showCancelButton: false,
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
      await vm.handleNicknameSet(nickname);
    }
  }
}

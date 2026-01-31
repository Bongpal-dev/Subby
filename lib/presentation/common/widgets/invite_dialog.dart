import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/util/invite_link_generator.dart';
import 'package:subby/presentation/common/widgets/app_button.dart';

/// Figma InputDialog 스타일 초대 다이얼로그
class InviteDialog extends StatelessWidget {
  final String groupCode;
  final String groupName;

  const InviteDialog({
    super.key,
    required this.groupCode,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10),
        child: Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: AppRadius.lgAll,
          ),
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextGroup (Title + Description)
              Column(
                children: [
                  Text(
                    '그룹 초대하기',
                    style: AppTypography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    '아래 초대 코드를 공유하여\n"$groupName" 그룹에 초대하세요',
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.s5),

              // Code TextField with copy button
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.bgTertiary,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colors.borderSecondary),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        groupCode,
                        style: AppTypography.body.copyWith(
                          color: colors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _copyCode(context),
                      child: Icon(
                        Icons.copy_outlined,
                        size: 20,
                        color: colors.iconSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              // Button
              SizedBox(
                height: 44,
                width: double.infinity,
                child: AppButton(
                  label: '링크 공유하기',
                  type: AppButtonType.primary,
                  onPressed: () => _shareCode(context),
                  isExpanded: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: groupCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('초대 코드가 복사되었습니다')),
    );
  }

  void _shareCode(BuildContext context) {
    final inviteLink = InviteLinkGenerator.generate(groupCode);
    Share.share(
      '$groupName 그룹에 초대합니다!\n\n초대 코드: $groupCode\n\n앱에서 참여하기: $inviteLink',
      subject: 'Subby 그룹 초대',
    );
  }
}

Future<void> showInviteDialog({
  required BuildContext context,
  required String groupCode,
  required String groupName,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return InviteDialog(
        groupCode: groupCode,
        groupName: groupName,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

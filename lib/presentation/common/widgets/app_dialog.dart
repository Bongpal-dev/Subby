import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 Dialog
/// - 배경: bgSecondary, 라운드: 16dp
/// - 패딩: 24dp, gap: 20dp
/// - 버튼: 높이 44dp, 라운드 12dp, gap 12dp
/// - 아이콘: 48px 고정
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.iconType,
    this.iconColor,
    required this.title,
    this.description,
    this.content,
    required this.actions,
  });

  final AppIconType? iconType;
  final Color? iconColor;
  final String title;
  final String? description;
  final Widget? content;
  final List<AppDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

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
              // Icon (optional) - 48px 고정
              if (iconType != null) ...[
                AppIcon(
                  iconType!,
                  size: 48,
                  color: iconColor ?? colors.iconPrimary,
                ),
                const SizedBox(height: AppSpacing.s5),
              ],

              // TextGroup: Title + Description
              Column(
                children: [
                  Text(
                    title,
                    style: AppTypography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      description!,
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),

              // Custom content (optional)
              if (content != null) ...[
                const SizedBox(height: AppSpacing.s5),
                content!,
              ],

              // ButtonRow
              const SizedBox(height: AppSpacing.s5),
              Row(
                children: actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;

                  return Expanded(
                    child: Row(
                      children: [
                        if (index > 0)
                          const SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: _DialogButton(
                            action: action,
                            isPrimary: action.isPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.action,
    required this.isPrimary,
  });

  final AppDialogAction action;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final bgColor = isPrimary ? colors.buttonPrimaryBg : Colors.transparent;
    final textColor = isPrimary ? colors.buttonPrimaryText : colors.buttonSecondaryText;
    final borderColor = isPrimary ? Colors.transparent : colors.borderPrimary;

    return Material(
      color: bgColor,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: AppRadius.mdAll,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            action.label,
            style: AppTypography.labelBold.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class AppDialogAction {
  const AppDialogAction({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
}

/// 커스텀 다이얼로그 표시 헬퍼
Future<T?> showAppDialog<T>({
  required BuildContext context,
  AppIconType? iconType,
  Color? iconColor,
  required String title,
  String? description,
  Widget? content,
  required List<AppDialogAction> actions,
  bool barrierDismissible = true,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final colors = isDark ? AppColors.dark : AppColors.light;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: colors.bgPrimary.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return AppDialog(
        iconType: iconType,
        iconColor: iconColor,
        title: title,
        description: description,
        content: content,
        actions: actions,
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

/// Figma 디자인 시스템 Divider
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      height: thickness,
      margin: EdgeInsets.only(left: indent, right: endIndent),
      color: color ?? colors.borderSecondary,
    );
  }
}

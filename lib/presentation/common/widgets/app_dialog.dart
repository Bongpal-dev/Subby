import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 Dialog
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    required this.actions,
  });

  final String title;
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
            color: colors.bgSecondary.withValues(alpha: 0.95),
            borderRadius: AppRadius.lgAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s6),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: AppTypography.title.copyWith(
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (content != null) ...[
                      const SizedBox(height: AppSpacing.s4),
                      content!,
                    ],
                  ],
                ),
              ),

              // Divider
              AppDivider(color: colors.borderSecondary),

              // Actions
              IntrinsicHeight(
                child: Row(
                  children: actions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final action = entry.value;

                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(action: action),
                          ),
                          if (index < actions.length - 1)
                            SizedBox(
                              width: 1,
                              child: Container(color: colors.borderSecondary),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final AppDialogAction action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    Color textColor;
    FontWeight fontWeight;

    if (action.isDestructive) {
      textColor = colors.statusError;
      fontWeight = FontWeight.w400;
    } else if (action.isDefault) {
      textColor = colors.textAccent;
      fontWeight = FontWeight.w600;
    } else {
      textColor = colors.textPrimary;
      fontWeight = FontWeight.w400;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: AppRadius.lgAll,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          alignment: Alignment.center,
          child: Text(
            action.label,
            style: AppTypography.bodyLarge.copyWith(
              color: textColor,
              fontWeight: fontWeight,
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
    this.isDestructive = false,
    this.isDefault = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;
}

/// 커스텀 다이얼로그 표시 헬퍼
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
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
        title: title,
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// 커스텀 다이얼로그
class AppDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<AppDialogAction> actions;

  const AppDialog({
    super.key,
    required this.title,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF2C2C2E).withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.95);
    final dividerColor = isDark
        ? const Color(0xFF545458).withValues(alpha: 0.6)
        : const Color(0xFF3C3C43).withValues(alpha: 0.2);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 44),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Content
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (content != null) ...[
                      SizedBox(height: AppSpacing.md),
                      content!,
                    ],
                  ],
                ),
              ),

              // Divider
              Container(height: 0.5, color: dividerColor),

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
                            Container(width: 0.5, color: dividerColor),
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
  final AppDialogAction action;

  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color textColor;
    FontWeight fontWeight;
    
    if (action.isDestructive) {
      textColor = Colors.red;
      fontWeight = FontWeight.w400;
    } else if (action.isDefault) {
      textColor = colorScheme.primary;
      fontWeight = FontWeight.w600;
    } else {
      textColor = colorScheme.primary;
      fontWeight = FontWeight.w400;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          alignment: Alignment.center,
          child: Text(
            action.label,
            style: AppTypography.titleLarge.copyWith(
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
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const AppDialogAction({
    required this.label,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// 커스텀 다이얼로그 표시 헬퍼
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  Widget? content,
  required List<AppDialogAction> actions,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.3),
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

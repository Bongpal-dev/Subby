import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 AppBar
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.centerTitle = true,
    this.useAccentBackground = false,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final bool useAccentBackground;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final backgroundColor = useAccentBackground ? colors.bgAccent : colors.bgPrimary;
    final textColor = useAccentBackground ? colors.textOnAccent : colors.textPrimary;
    final iconColor = useAccentBackground ? colors.iconOnAccent : colors.iconPrimary;

    Widget? leadingWidget = leading;
    if (showBackButton && leadingWidget == null) {
      leadingWidget = AppBarIconButton(
        icon: AppIconType.back,
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        color: iconColor,
      );
    }

    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            child: Row(
              children: [
                // Leading
                if (leadingWidget != null)
                  leadingWidget
                else
                  const SizedBox(width: 40),

                // Title
                Expanded(
                  child: title != null
                      ? Text(
                          title!,
                          style: AppTypography.title.copyWith(
                            color: textColor,
                          ),
                          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                        )
                      : const SizedBox.shrink(),
                ),

                // Actions
                if (actions != null && actions!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  )
                else
                  const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// AppBar 아이콘 버튼
class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final AppIconType icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.s5),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s2),
          child: AppIcon(
            icon,
            size: 24,
            color: color ?? colors.iconPrimary,
          ),
        ),
      ),
    );
  }
}

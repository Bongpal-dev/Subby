import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

enum SubbyButtonType {
  primary,
  outline,
  text,
}

/// Figma 디자인 시스템 버튼
class SubbyButton extends StatelessWidget {
  const SubbyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = SubbyButtonType.primary,
    this.isEnabled = true,
    this.isExpanded = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final SubbyButtonType type;
  final bool isEnabled;
  final bool isExpanded;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final backgroundColor = _getBackgroundColor(colors);
    final textColor = _getTextColor(colors);
    final borderColor = _getBorderColor(colors);

    Widget button = Material(
      color: backgroundColor,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s5,
            vertical: AppSpacing.s3,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: borderColor != null
                ? Border.all(color: borderColor)
                : null,
          ),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor, size: 20),
                  child: icon!,
                ),
                const SizedBox(width: AppSpacing.s2),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.bodySemi.copyWith(color: textColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Color _getBackgroundColor(AppColorScheme colors) {
    if (!isEnabled) {
      return colors.buttonDisableBg;
    }

    switch (type) {
      case SubbyButtonType.primary:
        return colors.buttonPrimaryBg;
      case SubbyButtonType.outline:
        return Colors.transparent;
      case SubbyButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor(AppColorScheme colors) {
    if (!isEnabled) {
      return colors.buttonDisableText;
    }

    switch (type) {
      case SubbyButtonType.primary:
        return colors.buttonPrimaryText;
      case SubbyButtonType.outline:
        return colors.buttonSecondaryText;
      case SubbyButtonType.text:
        return colors.buttonSecondaryText;
    }
  }

  Color? _getBorderColor(AppColorScheme colors) {
    if (!isEnabled) {
      return null;
    }

    switch (type) {
      case SubbyButtonType.primary:
        return null;
      case SubbyButtonType.outline:
        return colors.borderPrimary;
      case SubbyButtonType.text:
        return null;
    }
  }
}

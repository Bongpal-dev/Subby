import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_icons.dart';

/// Figma 디자인 시스템 FAB (Floating Action Button)
class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.onPressed,
    this.icon = AppIconType.plus,
  });

  final VoidCallback onPressed;
  final AppIconType icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Figma: buttonPrimaryBg 배경, buttonPrimaryText 아이콘
    return Material(
      color: colors.buttonPrimaryBg,
      borderRadius: AppRadius.lgAll,
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.lgAll,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: AppIcon(
            icon,
            size: 24,
            color: colors.buttonPrimaryText,
          ),
        ),
      ),
    );
  }
}

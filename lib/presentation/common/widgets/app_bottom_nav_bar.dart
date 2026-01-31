import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 Bottom Navigation Bar
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        border: Border(
          top: BorderSide(color: colors.borderSecondary),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavItemWidget(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final iconColor = isSelected ? colors.iconAccent : colors.iconSecondary;
    final textColor = isSelected ? colors.textAccent : colors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                item.icon,
                size: 24,
                color: iconColor,
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                item.label,
                style: AppTypography.caption.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation Item 데이터 클래스
class AppNavItem {
  const AppNavItem({
    required this.icon,
    required this.label,
  });

  final AppIconType icon;
  final String label;
}

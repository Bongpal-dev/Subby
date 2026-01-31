import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 Chip
class SubbyChip extends StatelessWidget {
  const SubbyChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final backgroundColor = isSelected ? colors.bgAccent : colors.bgSecondary;
    final textColor = isSelected ? colors.textOnAccent : colors.textSecondary;
    final borderColor = isSelected ? null : colors.borderSecondary;

    return Material(
      color: backgroundColor,
      borderRadius: AppRadius.fullAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.fullAll,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.fullAll,
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.label.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

/// Chip 그룹 (단일 선택)
class SubbyChipGroup extends StatelessWidget {
  const SubbyChipGroup({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s2,
      runSpacing: AppSpacing.s2,
      children: List.generate(
        labels.length,
        (index) => SubbyChip(
          label: labels[index],
          isSelected: index == selectedIndex,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

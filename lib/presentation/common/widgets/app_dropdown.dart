import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 Dropdown
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.label,
    this.itemBuilder,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? label;
  final Widget Function(T item)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s2),
        ],

        // Dropdown Button
        Material(
          color: colors.bgSecondary,
          borderRadius: AppRadius.mdAll,
          child: InkWell(
            onTap: () => _showDropdownMenu(context, colors),
            borderRadius: AppRadius.mdAll,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s4,
                vertical: AppSpacing.s3,
              ),
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: colors.borderSecondary),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value?.toString() ?? hint ?? '',
                      style: AppTypography.body.copyWith(
                        color: value != null
                            ? colors.textPrimary
                            : colors.textTertiary,
                      ),
                    ),
                  ),
                  AppIcon(
                    AppIconType.dropdown,
                    size: 20,
                    color: colors.iconSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownMenu(BuildContext context, AppColorScheme colors) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + button.size.height + 4,
        buttonPosition.dx + button.size.width,
        buttonPosition.dy + button.size.height + 200,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      color: colors.bgSecondary,
      items: items.map((item) {
        return PopupMenuItem<T>(
          value: item,
          child: itemBuilder?.call(item) ??
              Text(
                item.toString(),
                style: AppTypography.body.copyWith(color: colors.textPrimary),
              ),
        );
      }).toList(),
    ).then((selectedValue) {
      if (selectedValue != null) {
        onChanged(selectedValue);
      }
    });
  }
}

/// Dropdown Menu Item
class AppDropdownItem extends StatelessWidget {
  const AppDropdownItem({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: isSelected ? colors.textAccent : colors.textPrimary,
            ),
          ),
        ),
        if (isSelected)
          AppIcon(
            AppIconType.check,
            size: 20,
            color: colors.iconAccent,
          ),
      ],
    );
  }
}

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
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.label.copyWith(color: colors.textPrimary),
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
    // 메뉴 열기 전 포커스 해제 (키보드 닫기)
    FocusScope.of(context).unfocus();

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
      constraints: const BoxConstraints(maxHeight: 240),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      color: colors.bgSecondary,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.32),
      surfaceTintColor: Colors.transparent,
      menuPadding: const EdgeInsets.all(AppSpacing.s2),
      items: items.map((item) {
        final isSelected = item == value;
        return PopupMenuItem<T>(
          value: item,
          padding: EdgeInsets.zero,
          height: 48,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            decoration: BoxDecoration(
              color: isSelected ? colors.bgTertiary : Colors.transparent,
              borderRadius: AppRadius.smAll,
            ),
            child: itemBuilder?.call(item) ??
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.toString(),
                        style: AppTypography.body.copyWith(color: colors.textPrimary),
                      ),
                    ),
                    if (isSelected)
                      AppIcon(
                        AppIconType.check,
                        size: 24,
                        color: colors.bgAccent,
                      ),
                  ],
                ),
          ),
        );
      }).toList(),
    ).then((selectedValue) {
      if (selectedValue != null) {
        onChanged(selectedValue);
      }
      // 메뉴 닫힌 후 포커스 해제
      FocusManager.instance.primaryFocus?.unfocus();
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
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ),
        if (isSelected)
          AppIcon(
            AppIconType.check,
            size: 24,
            color: colors.bgAccent,
          ),
      ],
    );
  }
}

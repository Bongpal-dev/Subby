import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// 커스텀 텍스트 필드
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? value;
  final bool enabled;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final TextStyle? valueStyle;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.enabled = true,
    this.controller,
    this.onTap,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 더 연한 배경색
    final fillColor = isDark
        ? const Color(0xFF1C1C1E).withValues(alpha: 0.6)
        : const Color(0xFFF2F2F7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (optional)
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.captionLarge.copyWith(color: colors.textTertiary),
          ),
          SizedBox(height: AppSpacing.sm),
        ],

        // Input or Display
        if (enabled)
          FormField<String>(
            initialValue: controller?.text ?? '',
            validator: validator,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: AppTypography.bodyLarge.copyWith(
                          color: colors.textTertiary,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: AppTypography.bodyLarge,
                      onChanged: (value) {
                        state.didChange(value);
                        onChanged?.call(value);
                      },
                      maxLines: maxLines,
                    ),
                  ),
                  if (state.hasError || (showCounter && maxLength != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: state.hasError
                                ? Text(
                                    state.errorText!,
                                    style: AppTypography.captionSmall.copyWith(
                                      color: colorScheme.error,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          if (showCounter && maxLength != null)
                            Text(
                              '${controller?.text.length ?? 0}/$maxLength',
                              style: AppTypography.captionSmall.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          )
        else
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value ?? '',
                style: valueStyle ?? AppTypography.bodyLarge.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

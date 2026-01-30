import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 디자인 시스템 TextField
/// 상태: Default, Focused, Error, Disabled
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.height,
  });

  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextAlign textAlign;
  final double? height;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = _getBorderColor(colors, hasError);
    final fillColor = widget.enabled ? colors.bgTertiary : colors.buttonDisableBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.label.copyWith(
              color: widget.enabled ? colors.textPrimary : colors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
        ],

        // Input Field
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: widget.height ?? 52,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: borderColor),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.mdAll,
              child: Row(
              children: [
                if (widget.prefix != null) ...[
                  const SizedBox(width: AppSpacing.s4),
                  widget.prefix!,
                ],
                Expanded(
                  child: widget.onTap != null && widget.readOnly
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.prefix != null ? AppSpacing.s2 : AppSpacing.s4,
                          ),
                          child: Text(
                            widget.controller?.text.isNotEmpty == true
                                ? widget.controller!.text
                                : widget.hint ?? '',
                            style: AppTypography.body.copyWith(
                              color: widget.controller?.text.isNotEmpty == true
                                  ? colors.textPrimary
                                  : colors.textTertiary,
                            ),
                            textAlign: widget.textAlign,
                          ),
                        )
                      : TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          maxLines: widget.maxLines,
                          maxLength: widget.maxLength,
                          keyboardType: widget.keyboardType,
                          textInputAction: widget.textInputAction,
                          obscureText: widget.obscureText,
                          readOnly: widget.readOnly,
                          onTap: widget.onTap,
                          textAlign: widget.textAlign,
                          style: AppTypography.body.copyWith(
                            color: widget.enabled ? colors.textPrimary : colors.textTertiary,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hint,
                            hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
                            filled: false,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: widget.prefix != null ? AppSpacing.s2 : AppSpacing.s4,
                              vertical: AppSpacing.s4,
                            ),
                            counterText: '',
                          ),
                        ),
                ),
                if (widget.suffix != null) ...[
                  widget.suffix!,
                  const SizedBox(width: AppSpacing.s4),
                ],
              ],
            ),
            ),
          ),
        ),

        // Error Message
        if (hasError) ...[
          const SizedBox(height: AppSpacing.s1),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(color: colors.statusError),
          ),
        ],
      ],
    );
  }

  Color _getBorderColor(AppColorScheme colors, bool hasError) {
    if (!widget.enabled) {
      return colors.buttonDisableText;
    }
    if (hasError) {
      return colors.statusError;
    }
    if (_isFocused) {
      return colors.borderFocus;
    }
    return colors.borderSecondary;
  }
}

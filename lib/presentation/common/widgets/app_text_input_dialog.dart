import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_typography.dart';

/// 텍스트 입력 다이얼로그
class AppTextInputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final int? maxLength;
  final String cancelLabel;
  final String confirmLabel;
  final FormFieldValidator<String>? validator;

  const AppTextInputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.maxLength,
    this.cancelLabel = '취소',
    this.confirmLabel = '확인',
    this.validator,
  });

  @override
  State<AppTextInputDialog> createState() => _AppTextInputDialogState();
}

class _AppTextInputDialogState extends State<AppTextInputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _showLimitError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (widget.maxLength != null && value.length > widget.maxLength!) {
      final trimmed = value.substring(0, widget.maxLength!);
      _controller.text = trimmed;
      _controller.selection = TextSelection.collapsed(offset: trimmed.length);
      setState(() => _showLimitError = true);
    } else {
      if (_showLimitError) {
        setState(() => _showLimitError = false);
      }
    }
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;

    final value = _controller.text.trim();
    if (value.isEmpty) return;

    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isDark
        ? const Color(0xFF2C2C2E).withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.95);
    final dividerColor = isDark
        ? const Color(0xFF545458).withValues(alpha: 0.6)
        : const Color(0xFF3C3C43).withValues(alpha: 0.2);
    final fillColor = isDark
        ? const Color(0xFF1C1C1E).withValues(alpha: 0.6)
        : const Color(0xFFF2F2F7);

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
              // Title + Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: FormField<String>(
                        initialValue: _controller.text,
                        validator: widget.validator,
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
                                  controller: _controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: widget.hint,
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
                                    _onTextChanged(value);
                                  },
                                ),
                              ),
                              if (state.hasError ||
                                  (widget.maxLength != null))
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: state.hasError
                                            ? Text(
                                                state.errorText!,
                                                style: AppTypography.captionSmall
                                                    .copyWith(
                                                  color: colorScheme.error,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      if (widget.maxLength != null)
                                        Text(
                                          '${_controller.text.length}/${widget.maxLength}',
                                          style:
                                              AppTypography.captionSmall.copyWith(
                                            color: colors.textTertiary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(height: 0.5, color: dividerColor),

              // Actions
              IntrinsicHeight(
                child: Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: _ActionButton(
                        label: widget.cancelLabel,
                        onPressed: () => Navigator.pop(context),
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(width: 0.5, color: dividerColor),
                    // Confirm
                    Expanded(
                      child: _ActionButton(
                        label: widget.confirmLabel,
                        onPressed: _onConfirm,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final FontWeight fontWeight;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.titleLarge.copyWith(
              color: color,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

/// 텍스트 입력 다이얼로그 표시 헬퍼
Future<String?> showAppTextInputDialog({
  required BuildContext context,
  required String title,
  String? hint,
  String? initialValue,
  int? maxLength,
  String cancelLabel = '취소',
  String confirmLabel = '확인',
  FormFieldValidator<String>? validator,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return AppTextInputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        maxLength: maxLength,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        validator: validator,
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

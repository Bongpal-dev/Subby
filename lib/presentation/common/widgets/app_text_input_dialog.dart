import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/app_button.dart';

/// Figma InputDialog 컴포넌트
class AppTextInputDialog extends StatefulWidget {
  final String title;
  final String? description;
  final String? hint;
  final String? initialValue;
  final int? maxLength;
  final String cancelLabel;
  final String confirmLabel;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final String Function()? onGenerateValue;

  const AppTextInputDialog({
    super.key,
    required this.title,
    this.description,
    this.hint,
    this.initialValue,
    this.maxLength,
    this.cancelLabel = '취소',
    this.confirmLabel = '확인',
    this.validator,
    this.suffixIcon,
    this.onGenerateValue,
  });

  @override
  State<AppTextInputDialog> createState() => _AppTextInputDialogState();
}

class _AppTextInputDialogState extends State<AppTextInputDialog> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();
  String? _errorText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // maxLength 초과 시 자르기
    if (widget.maxLength != null && value.length > widget.maxLength!) {
      final trimmed = value.substring(0, widget.maxLength!);
      _controller.text = trimmed;
      _controller.selection = TextSelection.collapsed(offset: trimmed.length);
    }

    // 에러 메시지 업데이트
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_controller.text);
      });
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
    final colors = context.colors;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10),
        child: Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: AppRadius.lgAll,
          ),
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextGroup (Title + Description)
              Column(
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.description != null) ...[
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      widget.description!,
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppSpacing.s5),

              // TextField
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.bgTertiary,
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(
                          color: _isFocused ? colors.borderFocus : colors.borderSecondary,
                        ),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        autofocus: true,
                        validator: widget.validator,
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          hintStyle: AppTypography.body.copyWith(
                            color: colors.textTertiary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s4,
                            vertical: AppSpacing.s4,
                          ),
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                          suffixIcon: widget.suffixIcon != null
                              ? GestureDetector(
                                  onTap: () {
                                    if (widget.onGenerateValue != null) {
                                      final newValue = widget.onGenerateValue!();
                                      _controller.text = newValue;
                                      _controller.selection = TextSelection.collapsed(
                                        offset: newValue.length,
                                      );
                                      setState(() {
                                        _errorText = null;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: AppSpacing.s3),
                                    child: widget.suffixIcon,
                                  ),
                                )
                              : null,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: colors.textPrimary,
                        ),
                        onChanged: _onTextChanged,
                      ),
                    ),
                    // Error/Counter row
                    if (_errorText != null || widget.maxLength != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.s2),
                        child: Row(
                          children: [
                            Expanded(
                              child: _errorText != null
                                  ? Text(
                                      _errorText!,
                                      style: AppTypography.caption.copyWith(
                                        color: colors.statusError,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            if (widget.maxLength != null)
                              Text(
                                '${_controller.text.length}/${widget.maxLength}',
                                style: AppTypography.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              // ButtonRow
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: AppButton(
                        label: widget.cancelLabel,
                        type: AppButtonType.outline,
                        onPressed: () => Navigator.pop(context),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: AppButton(
                        label: widget.confirmLabel,
                        type: AppButtonType.primary,
                        onPressed: _onConfirm,
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
  String? description,
  String? hint,
  String? initialValue,
  int? maxLength,
  String cancelLabel = '취소',
  String confirmLabel = '확인',
  FormFieldValidator<String>? validator,
  Widget? suffixIcon,
  String Function()? onGenerateValue,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return AppTextInputDialog(
        title: title,
        description: description,
        hint: hint,
        initialValue: initialValue,
        maxLength: maxLength,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        validator: validator,
        suffixIcon: suffixIcon,
        onGenerateValue: onGenerateValue,
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

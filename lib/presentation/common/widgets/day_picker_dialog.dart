import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_spacing.dart';

/// 결제일 선택 다이얼로그 (1-31일)
class DayPickerDialog extends StatefulWidget {
  final int initialDay;

  const DayPickerDialog({
    super.key,
    required this.initialDay,
  });

  @override
  State<DayPickerDialog> createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<DayPickerDialog> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = isDark
        ? const Color(0xFF2C2C2E).withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.95);
    final dividerColor = isDark
        ? const Color(0xFF545458).withValues(alpha: 0.6)
        : const Color(0xFF3C3C43).withValues(alpha: 0.2);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  children: [
                    Text(
                      '결제일 선택',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.s4),

                    // 날짜 그리드
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 44,
                      ),
                      itemCount: 31,
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isSelected = _selectedDay == day;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = day),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSpacing.s4),

                    // 선택된 날짜 표시
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '매월 $_selectedDay일',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
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
                    Expanded(
                      child: _ActionButton(
                        label: '취소',
                        onPressed: () => Navigator.pop(context),
                        dividerColor: dividerColor,
                        showDivider: true,
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        label: '확인',
                        onPressed: () => Navigator.pop(context, _selectedDay),
                        isDefault: true,
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
  final bool isDefault;
  final bool showDivider;
  final Color? dividerColor;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.isDefault = false,
    this.showDivider = false,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s3),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: isDefault ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showDivider && dividerColor != null)
          Container(width: 0.5, color: dividerColor),
      ],
    );
  }
}

/// 결제일 선택 다이얼로그 표시 헬퍼
Future<int?> showDayPickerDialog({
  required BuildContext context,
  required int initialDay,
}) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return DayPickerDialog(initialDay: initialDay);
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

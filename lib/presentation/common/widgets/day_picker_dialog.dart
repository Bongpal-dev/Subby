import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';

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
    final colors = context.subbyColor;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: AppRadius.lgAll,
          ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                '결제일 선택',
                style: AppTypography.title.copyWith(color: colors.onSurface),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.s6),

              // 날짜 그리드
              LayoutBuilder(
                builder: (context, constraints) {
                  final cellSize = constraints.maxWidth / 7;
                  return Wrap(
                    children: List.generate(31, (index) {
                      final day = index + 1;
                      final isSelected = _selectedDay == day;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: SizedBox(
                          width: cellSize,
                          height: cellSize,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: AppTypography.body.copyWith(
                                  color: isSelected
                                      ? colors.onPrimary
                                      : colors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              SizedBox(height: AppSpacing.s6),

              // 선택하기 버튼
              SubbyButton(
                label: '선택하기',
                onPressed: () => Navigator.pop(context, _selectedDay),
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
      ),
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
    barrierColor: Colors.black.withValues(alpha: 0.5),
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

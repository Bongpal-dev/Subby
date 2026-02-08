import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';

/// 월/일 선택 다이얼로그 (연간 결제용)
class MonthDayPickerDialog extends StatefulWidget {
  final int initialMonth;
  final int initialDay;

  const MonthDayPickerDialog({
    super.key,
    required this.initialMonth,
    required this.initialDay,
  });

  @override
  State<MonthDayPickerDialog> createState() => _MonthDayPickerDialogState();
}

class _MonthDayPickerDialogState extends State<MonthDayPickerDialog> {
  late int _selectedMonth;
  late int _selectedDay;
  late PageController _pageController;
  static const int _initialPage = 1200; // 중간에서 시작

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedDay = widget.initialDay;
    // 초기 월에 맞는 페이지로 시작 (1200 + 월 오프셋)
    final initialPageOffset = _initialPage + (_selectedMonth - 1);
    _pageController = PageController(initialPage: initialPageOffset);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int month) {
    // 윤년 무시, 각 월의 일수
    const daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  void _previousMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _nextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _selectedMonth = (page % 12) + 1;
      // 선택된 일이 해당 월의 최대 일수를 초과하면 조정
      final maxDay = _getDaysInMonth(_selectedMonth);
      if (_selectedDay > maxDay) {
        _selectedDay = maxDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.s4),
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

              // 월 네비게이션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    '$_selectedMonth월',
                    style: AppTypography.bodyLargeSemi.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s6),

              // 날짜 그리드 (스와이프로 월 변경)
              LayoutBuilder(
                builder: (context, constraints) {
                  final cellSize = constraints.maxWidth / 7;
                  final gridHeight = cellSize * 5; // 최대 5행

                  return SizedBox(
                    height: gridHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, pageIndex) {
                        final month = (pageIndex % 12) + 1;
                        final daysInMonth = _getDaysInMonth(month);

                        return Wrap(
                          children: List.generate(daysInMonth, (index) {
                            final day = index + 1;
                            final isSelected =
                                _selectedMonth == month && _selectedDay == day;

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
                  );
                },
              ),
              SizedBox(height: AppSpacing.s6),

              // 선택하기 버튼
              SubbyButton(
                label: '선택하기',
                onPressed: () => Navigator.pop(
                  context,
                  (month: _selectedMonth, day: _selectedDay),
                ),
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 월/일 선택 다이얼로그 표시 헬퍼
Future<({int month, int day})?> showMonthDayPickerDialog({
  required BuildContext context,
  required int initialMonth,
  required int initialDay,
}) {
  return showGeneralDialog<({int month, int day})>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return MonthDayPickerDialog(
        initialMonth: initialMonth,
        initialDay: initialDay,
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

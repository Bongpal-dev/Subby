import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_typography.dart';

/// 금액 증감 단위 선택 위젯
class StepSelector extends StatelessWidget {
  final String currency;
  final num currentStep;
  final ValueChanged<num> onStepChanged;

  const StepSelector({
    super.key,
    required this.currency,
    required this.currentStep,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = currency == 'KRW'
        ? const [100, 1000, 10000]
        : const [0.1, 1.0, 10.0];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: steps.map((step) {
          final isSelected = step == currentStep;
          final label = _formatLabel(step);

          return Expanded(
            child: GestureDetector(
              onTap: () => onStepChanged(step),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatLabel(num step) {
    if (currency == 'KRW') {
      final intStep = step.toInt();
      return '\u20a9${intStep.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    } else {
      final doubleStep = step.toDouble();
      return '\$${doubleStep.toString().replaceAll(RegExp(r'\.0$'), '')}';
    }
  }
}

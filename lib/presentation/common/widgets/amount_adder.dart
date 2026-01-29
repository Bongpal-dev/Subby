import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/util/currency_formatter.dart';

/// 금액 추가 버튼 위젯
class AmountAdder extends StatelessWidget {
  final String currency;
  final ValueChanged<num> onAdd;

  const AmountAdder({
    super.key,
    required this.currency,
    required this.onAdd,
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
          final label = _formatLabel(step);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onAdd(step),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: AppTypography.label.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
      return '+\u20a9${CurrencyFormatter.formatKrw(step.toInt())}';
    } else {
      final formatted = step.toString().replaceAll(RegExp(r'\.0$'), '');
      return '+\$$formatted';
    }
  }
}

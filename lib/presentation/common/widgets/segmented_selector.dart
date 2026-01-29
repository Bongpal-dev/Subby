import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_typography.dart';

/// iOS 스타일 Segmented Control
class SegmentedSelector extends StatelessWidget {
  final List<String> options;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onChanged;
  final bool compact;

  const SegmentedSelector({
    super.key,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = selected == options[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(options[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(vertical: compact ? 8 : 10),
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
                    labels[index],
                    style: (compact ? AppTypography.label : AppTypography.label).copyWith(
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/subscription_conflict.dart';

Future<ConflictResolution?> showConflictResolutionDialog({
  required BuildContext context,
  required SubscriptionConflict conflict,
}) {
  return showDialog<ConflictResolution>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _ConflictResolutionDialog(conflict: conflict),
  );
}

class _ConflictResolutionDialog extends StatefulWidget {
  final SubscriptionConflict conflict;

  const _ConflictResolutionDialog({required this.conflict});

  @override
  State<_ConflictResolutionDialog> createState() => _ConflictResolutionDialogState();
}

class _ConflictResolutionDialogState extends State<_ConflictResolutionDialog> {
  ConflictResolution? _selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text('어떤 값을 사용할까요?', style: AppTypography.headline),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\'${widget.conflict.localSubscription.name}\'',
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          _buildOptionCard(
            context: context,
            title: '이 기기에서 수정',
            resolution: ConflictResolution.keepLocal,
            values: widget.conflict.conflicts
                .map((f) => '${f.fieldName}: ${f.localValue}')
                .toList(),
          ),
          SizedBox(height: AppSpacing.s2),
          _buildOptionCard(
            context: context,
            title: '클라우드 값',
            resolution: ConflictResolution.useServer,
            values: widget.conflict.conflicts
                .map((f) => '${f.fieldName}: ${f.serverValue}')
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _selected == null
              ? null
              : () => Navigator.of(context).pop(_selected),
          child: Text(
            '확인',
            style: TextStyle(
              color: _selected == null
                  ? colorScheme.onSurface.withValues(alpha: 0.38)
                  : colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required ConflictResolution resolution,
    required List<String> values,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selected == resolution;

    return GestureDetector(
      onTap: () => setState(() => _selected = resolution),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  size: 20,
                ),
                SizedBox(width: AppSpacing.s2),
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s2),
            ...values.map(
              (v) => Padding(
                padding: EdgeInsets.only(left: 28),
                child: Text(
                  v,
                  style: AppTypography.body.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/subscription_conflict.dart';
import 'package:subby/presentation/common/widgets/app_dialog.dart';

/// 충돌 해결 다이얼로그 표시
Future<ConflictResolution?> showConflictResolutionDialog({
  required BuildContext context,
  required SubscriptionConflict conflict,
}) {
  return showAppDialog<ConflictResolution>(
    context: context,
    title: '데이터 충돌',
    barrierDismissible: false,
    content: _ConflictCompareContent(conflict: conflict),
    actions: [
      AppDialogAction(
        label: '내 변경 유지',
        onPressed: () => Navigator.of(context).pop(ConflictResolution.keepLocal),
      ),
      AppDialogAction(
        label: '서버 값 사용',
        isDefault: true,
        onPressed: () => Navigator.of(context).pop(ConflictResolution.useServer),
      ),
    ],
  );
}

class _ConflictCompareContent extends StatelessWidget {
  final SubscriptionConflict conflict;

  const _ConflictCompareContent({required this.conflict});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '\'${conflict.localSubscription.name}\'',
          style: AppTypography.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ...conflict.conflicts.map(
          (field) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    field.fieldName,
                    style: AppTypography.captionLarge,
                  ),
                ),
                Expanded(
                  child: Text(
                    field.localValue.isEmpty ? '-' : field.localValue,
                    style: AppTypography.captionLarge.copyWith(
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    field.serverValue.isEmpty ? '-' : field.serverValue,
                    style: AppTypography.captionLarge.copyWith(
                      color: colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

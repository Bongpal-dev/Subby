import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/subscription_conflict.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';

Future<ConflictResolution?> showConflictResolutionDialog({
  required BuildContext context,
  required SubscriptionConflict conflict,
}) {
  return showGeneralDialog<ConflictResolution>(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _ConflictResolutionDialog(conflict: conflict);
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
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                '어떤 값을 사용할까요?',
                style: AppTypography.title.copyWith(
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s2),

              // Subtitle
              Text(
                '\'${widget.conflict.localSubscription.name}\'',
                style: AppTypography.body.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s5),

              // Options
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

              const SizedBox(height: AppSpacing.s5),

              // Confirm button
              SizedBox(
                height: 44,
                width: double.infinity,
                child: SubbyButton(
                  label: '확인',
                  type: SubbyButtonType.primary,
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.of(context).pop(_selected),
                  isExpanded: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required ConflictResolution resolution,
    required List<String> values,
  }) {
    final colors = context.subbyColor;
    final isSelected = _selected == resolution;

    return GestureDetector(
      onTap: () => setState(() => _selected = resolution),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primaryContainer
              : colors.surfaceContainerHighest,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: isSelected ? colors.primary : Colors.transparent,
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
                  color: isSelected ? colors.primary : colors.outline,
                  size: 20,
                ),
                SizedBox(width: AppSpacing.s2),
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? colors.onPrimaryContainer
                        : colors.onSurface,
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
                        ? colors.onPrimaryContainer
                        : colors.onSurfaceVariant,
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

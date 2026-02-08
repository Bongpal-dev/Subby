import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';

/// Figma 코치마크 ToolTip 컴포넌트
/// - 배경: surfaceContainer, 라운드: 12dp
/// - 패딩: 16dp, gap: 8dp
/// - 제목: bodyLargeSemi (16px, SemiBold)
/// - 설명: body (14px, Regular, onSurfaceVariant)
class SubbyTooltip extends StatelessWidget {
  const SubbyTooltip({
    super.key,
    required this.title,
    required this.description,
    this.width = 280,
  });

  final String title;
  final String description;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: AppRadius.smAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyLargeSemi.copyWith(
              color: colors.onSurface,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            description,
            style: AppTypography.body.copyWith(
              color: colors.onSurfaceVariant,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

/// 코치마크 오버레이
/// 특정 영역을 하이라이트하고 툴팁을 표시
class CoachMarkOverlay extends StatelessWidget {
  const CoachMarkOverlay({
    super.key,
    required this.title,
    required this.description,
    required this.targetKey,
    this.tooltipPosition = TooltipPosition.top,
    this.onTap,
  });

  final String title;
  final String description;
  final GlobalKey targetKey;
  final TooltipPosition tooltipPosition;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Dim 배경
            Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
            // 툴팁 위치 계산
            Builder(
              builder: (context) {
                final renderBox = targetKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                if (renderBox == null) {
                  return const SizedBox.shrink();
                }

                final position = renderBox.localToGlobal(Offset.zero);
                final size = renderBox.size;

                return Stack(
                  children: [
                    // 하이라이트 영역 (구멍 뚫기)
                    Positioned(
                      left: position.dx - 8,
                      top: position.dy - 8,
                      child: Container(
                        width: size.width + 16,
                        height: size.height + 16,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: AppRadius.lgAll,
                        ),
                      ),
                    ),
                    // 툴팁
                    Positioned(
                      left: _getTooltipLeft(position, size, context),
                      top: _getTooltipTop(position, size),
                      child: SubbyTooltip(
                        title: title,
                        description: description,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _getTooltipLeft(Offset position, Size size, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const tooltipWidth = 280.0;

    switch (tooltipPosition) {
      case TooltipPosition.top:
      case TooltipPosition.bottom:
        // 타겟 중앙에 맞추되, 화면 밖으로 나가지 않게
        final centerX = position.dx + size.width / 2 - tooltipWidth / 2;
        return centerX.clamp(16.0, screenWidth - tooltipWidth - 16);
      case TooltipPosition.left:
        return position.dx - tooltipWidth - 16;
      case TooltipPosition.right:
        return position.dx + size.width + 16;
    }
  }

  double _getTooltipTop(Offset position, Size size) {
    switch (tooltipPosition) {
      case TooltipPosition.top:
        return position.dy - 100; // 툴팁 높이 + 여백
      case TooltipPosition.bottom:
        return position.dy + size.height + 16;
      case TooltipPosition.left:
      case TooltipPosition.right:
        return position.dy + size.height / 2 - 40;
    }
  }
}

enum TooltipPosition { top, bottom, left, right }

/// 코치마크 표시 헬퍼
Future<void> showCoachMark({
  required BuildContext context,
  required String title,
  required String description,
  required GlobalKey targetKey,
  TooltipPosition tooltipPosition = TooltipPosition.top,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return CoachMarkOverlay(
        title: title,
        description: description,
        targetKey: targetKey,
        tooltipPosition: tooltipPosition,
        onTap: () => Navigator.pop(context),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

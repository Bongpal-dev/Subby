import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';

class SubbyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const SubbyCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;

    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: child,
    );
  }
}

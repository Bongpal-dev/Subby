import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';

/// Figma 디자인 시스템 토글 스위치
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  static const _toggleShadow = BoxShadow(
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? colors.bgAccent : colors.bgTertiary,
          borderRadius: AppRadius.fullAll,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.fullAll,
              boxShadow: const [_toggleShadow],
            ),
          ),
        ),
      ),
    );
  }
}

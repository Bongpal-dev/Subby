import 'package:flutter/material.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';

/// 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        backgroundColor: colors.bgSecondary,
        foregroundColor: colors.iconPrimary,
        elevation: 0,
      ),
      backgroundColor: colors.bgPrimary,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // 앱 정보 섹션
          _SettingsSection(
            title: '앱 정보',
            children: [
              _SettingsItem(
                title: '버전',
                trailing: Text(
                  '1.0.0',
                  style: AppTypography.body.copyWith(color: colors.textTertiary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.s4,
            bottom: AppSpacing.s2,
          ),
          child: Text(
            title,
            style: AppTypography.label.copyWith(color: colors.textSecondary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(AppSpacing.s3),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    this.trailing,
    this.onTap,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

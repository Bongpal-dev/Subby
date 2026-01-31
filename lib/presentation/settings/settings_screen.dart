import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';

/// 설정 화면
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppAppBar(
        title: '설정',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s6,
          vertical: AppSpacing.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 설정 섹션
            SettingGroup(
              label: '앱 설정',
              children: [
                SettingItem(
                  title: '다크 모드',
                  value: '시스템 설정에 맞춤',
                  type: SettingItemType.chevron,
                  onTap: () {
                    // TODO: 다크 모드 설정 화면으로 이동
                  },
                ),
                SettingItem(
                  title: '알림 설정',
                  type: SettingItemType.toggle,
                  toggleValue: _notificationEnabled,
                  onToggleChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                ),
                SettingItem(
                  title: '기본 통화',
                  value: 'KRW',
                  type: SettingItemType.chevron,
                  onTap: () {
                    // TODO: 통화 선택 화면으로 이동
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s6),
            // 정보 섹션
            SettingGroup(
              label: '정보',
              children: [
                SettingItem(
                  title: '버전',
                  value: _appVersion,
                  type: SettingItemType.none,
                ),
                SettingItem(
                  title: '이용약관',
                  type: SettingItemType.chevron,
                  onTap: () {
                    // TODO: 이용약관 화면으로 이동
                  },
                ),
                SettingItem(
                  title: '개인정보처리방침',
                  type: SettingItemType.chevron,
                  onTap: () {
                    // TODO: 개인정보처리방침 화면으로 이동
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 설정 그룹 컴포넌트
class SettingGroup extends StatelessWidget {
  const SettingGroup({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
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
            left: 10,
            bottom: AppSpacing.s2,
          ),
          child: Text(
            label,
            style: AppTypography.label.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        ...children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isFirst = index == 0;
          final isLast = index == children.length - 1;

          return Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : AppSpacing.s2,
            ),
            child: _SettingItemContainer(
              isFirst: isFirst,
              isLast: isLast,
              child: child,
            ),
          );
        }),
      ],
    );
  }
}

/// 설정 아이템 컨테이너 (각 아이템별 독립적인 배경)
class _SettingItemContainer extends StatelessWidget {
  const _SettingItemContainer({
    required this.child,
    required this.isFirst,
    required this.isLast,
  });

  final Widget child;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: AppRadius.mdAll,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// 설정 아이템 타입
enum SettingItemType {
  chevron, // 화살표 + 선택적 값
  none, // 값만 표시 (화살표 없음)
  toggle, // 토글 스위치
}

/// 설정 아이템 컴포넌트
class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    this.value,
    required this.type,
    this.onTap,
    this.toggleValue,
    this.onToggleChanged,
  });

  final String title;
  final String? value;
  final SettingItemType type;
  final VoidCallback? onTap;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: type == SettingItemType.toggle ? null : onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpacing.s3),
                Text(
                  value!,
                  style: AppTypography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
              if (type == SettingItemType.chevron) ...[
                const SizedBox(width: AppSpacing.s3),
                AppIcon(
                  AppIconType.next,
                  size: 24,
                  color: colors.iconSecondary,
                ),
              ],
              if (type == SettingItemType.toggle)
                AppToggle(
                  value: toggleValue ?? false,
                  onChanged: onToggleChanged,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/auth/login_screen.dart';
import 'package:subby/presentation/home/home_view_model.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/settings/settings_screen.dart';
import 'package:subby/core/utils/nickname_generator.dart';
import 'package:subby/presentation/common/group_actions.dart';

/// Figma Drawer 디자인
/// - 너비: 300dp
/// - 배경: bgSecondary
/// - 패딩: horizontal 16dp, vertical 24dp
/// - gap: 24dp
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final isAnonymous = ref.watch(isAnonymousProvider).valueOrNull ?? true;

    // 키보드가 올라와도 Drawer 레이아웃이 변하지 않도록 높이 고정
    // viewPadding은 키보드 상태와 관계없이 시스템 UI 영역 반환
    final mediaQuery = MediaQuery.of(context);
    final drawerHeight = mediaQuery.size.height - mediaQuery.viewPadding.top;
    final bottomPadding = mediaQuery.viewPadding.bottom;

    return Drawer(
      width: 300,
      backgroundColor: colors.bgSecondary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: drawerHeight,
          child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.s4,
            right: AppSpacing.s4,
            top: AppSpacing.s4,
            bottom: AppSpacing.s4 + bottomPadding,
          ),
          child: Column(
            children: [
              // ProfileSection
              _ProfileSection(
                onEditNicknameTap: () => _showEditNicknameDialog(context, ref),
              ),

              const SizedBox(height: AppSpacing.s4),
              const AppDivider(),
              const SizedBox(height: AppSpacing.s4),

              // GroupSection (scrollable)
              Expanded(
                child: _GroupSection(
                  groups: state.groups,
                  selectedGroupCode: state.selectedGroupCode,
                  onGroupTap: (groupCode) {
                    ref.read(homeViewModelProvider.notifier).selectGroup(groupCode);
                    Navigator.pop(context);
                  },
                  onGroupEdit: (groupCode, currentName) =>
                      _showRenameGroupDialog(context, ref, groupCode, currentName),
                  onGroupInvite: (groupCode, groupName) =>
                      _showInviteGroupDialog(context, ref, groupCode, groupName),
                  onGroupLeave: (groupCode, groupName) =>
                      _showLeaveGroupDialog(context, ref, groupCode, groupName),
                ),
              ),

              const AppDivider(),
              const SizedBox(height: AppSpacing.s4),

              // GroupAddItems Section
              _SvgMenuItem(
                iconPath: 'assets/icons/ic_plus_small.svg',
                label: '새 그룹 만들기',
                iconColor: colors.iconSecondary,
                labelColor: colors.textSecondary,
                onTap: () => showCreateGroupFlow(context, ref),
              ),
              const SizedBox(height: AppSpacing.s2),
              _SvgMenuItem(
                iconPath: 'assets/icons/ic_mail.svg',
                iconSize: 20,
                label: '그룹 참여하기',
                iconColor: colors.iconSecondary,
                labelColor: colors.textSecondary,
                onTap: () => showJoinGroupFlow(context, ref),
              ),

              const SizedBox(height: AppSpacing.s4),
              const AppDivider(),
              const SizedBox(height: AppSpacing.s4),

              // MenuItems Section
              if (!isAnonymous)
                _MenuItem(
                  icon: Icons.logout,
                  label: '로그아웃',
                  onTap: () => _showSignOutDialog(context, ref),
                ),
              if (isAnonymous)
                _MenuItem(
                  icon: Icons.login,
                  label: '로그인',
                  onTap: () => _navigateToLogin(context),
                ),
              const SizedBox(height: AppSpacing.s2),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: '설정',
                onTap: () => _navigateToSettings(context),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Future<void> _showEditNicknameDialog(BuildContext context, WidgetRef ref) async {
    final currentNickname = ref.read(currentNicknameProvider).valueOrNull;
    final nicknameRepository = ref.read(nicknameRepositoryProvider);
    final authDataSource = ref.read(firebaseAuthDataSourceProvider);
    final userId = authDataSource.currentUserId;
    final groups = ref.read(homeViewModelProvider).groups;

    if (userId == null) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final newNickname = await showAppTextInputDialog(
      context: context,
      title: '닉네임 변경',
      hint: '닉네임을 입력하세요',
      initialValue: currentNickname ?? NicknameGenerator.generate(),
      maxLength: 20,
      confirmLabel: '저장',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '닉네임을 입력해주세요';
        }
        return null;
      },
      suffixIcon: SvgPicture.asset(
        'assets/icons/ic_refresh_small.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          colors.iconSecondary,
          BlendMode.srcIn,
        ),
      ),
      onGenerateValue: NicknameGenerator.generate,
    );

    if (newNickname != null && context.mounted) {
      final groupCodes = groups.map((g) => g.code).toList();
      await nicknameRepository.saveNickname(userId, newNickname, groupCodes);
      ref.invalidate(currentNicknameProvider);
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _showRenameGroupDialog(
    BuildContext context,
    WidgetRef ref,
    String groupCode,
    String currentName,
  ) async {
    final newName = await showAppTextInputDialog(
      context: context,
      title: '그룹 이름 변경',
      hint: '그룹 이름을 입력하세요',
      initialValue: currentName,
      maxLength: 10,
      confirmLabel: '저장',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '그룹 이름을 입력해주세요';
        }
        return null;
      },
    );

    if (newName != null && context.mounted) {
      final groupRepository = ref.read(groupRepositoryProvider);
      await groupRepository.updateDisplayName(groupCode, newName);
    }
  }

  void _showInviteGroupDialog(
    BuildContext context,
    WidgetRef ref,
    String groupCode,
    String groupName,
  ) {
    showInviteDialog(
      context: context,
      groupCode: groupCode,
      groupName: groupName,
    );
  }

  void _showLeaveGroupDialog(
    BuildContext context,
    WidgetRef ref,
    String groupCode,
    String groupName,
  ) {
    showDialog(
      context: context,
      builder: (context) => _LeaveGroupDialog(
        groupCode: groupCode,
        groupName: groupName,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showAppDialog(
      context: context,
      title: '로그아웃',
      description: '로그아웃하면 이 기기의 데이터가 삭제됩니다.\n계속하시겠습니까?',
      actions: [
        AppDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context),
        ),
        AppDialogAction(
          label: '로그아웃',
          isPrimary: true,
          isDestructive: true,
          onPressed: () async {
            Navigator.pop(context); // 다이얼로그 닫기
            Navigator.pop(context); // Drawer 닫기

            // 로컬 데이터 삭제
            final db = ref.read(databaseProvider);
            await db.clearUserData();

            // 로그아웃 및 익명 로그인
            final authDataSource = ref.read(firebaseAuthDataSourceProvider);
            await authDataSource.signOut();
            await authDataSource.signInAnonymously();

            // 홈 화면 새로고침
            ref.invalidate(homeViewModelProvider);
          },
        ),
      ],
    );
  }
}

/// ProfileSection: 사용자 닉네임 + 편집 아이콘
class _ProfileSection extends ConsumerWidget {
  const _ProfileSection({
    required this.onEditNicknameTap,
  });

  final VoidCallback onEditNicknameTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final nickname = ref.watch(currentNicknameProvider).valueOrNull;

    return Row(
      children: [
        Expanded(
          child: Text(
            nickname ?? '닉네임 없음',
            style: AppTypography.bodyLargeSemi.copyWith(
              color: colors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        GestureDetector(
          onTap: onEditNicknameTap,
          child: SvgPicture.asset(
            'assets/icons/ic_edit.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              colors.iconPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

/// GroupSection: 그룹 목록 (스크롤)
class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.groups,
    required this.selectedGroupCode,
    required this.onGroupTap,
    required this.onGroupEdit,
    required this.onGroupInvite,
    required this.onGroupLeave,
  });

  final List<dynamic> groups;
  final String? selectedGroupCode;
  final void Function(String) onGroupTap;
  final void Function(String, String) onGroupEdit;
  final void Function(String, String) onGroupInvite;
  final void Function(String, String) onGroupLeave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Text(
            '참여 중인 그룹이 없습니다',
            style: AppTypography.body.copyWith(
              color: colors.textTertiary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s2,
      ),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s2),
      itemBuilder: (context, index) {
        final group = groups[index];
        final isSelected = selectedGroupCode == group.code;
        final memberCount = group.members.length;

        return _GroupItem(
          name: group.effectiveName,
          memberCount: memberCount,
          isSelected: isSelected,
          onTap: () => onGroupTap(group.code),
          onEdit: () => onGroupEdit(group.code, group.effectiveName),
          onInvite: () => onGroupInvite(group.code, group.effectiveName),
          onLeave: () => onGroupLeave(group.code, group.effectiveName),
        );
      },
    );
  }
}

/// GroupItem: 그룹 아이템
class _GroupItem extends StatelessWidget {
  const _GroupItem({
    required this.name,
    required this.memberCount,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onInvite,
    required this.onLeave,
  });

  final String name;
  final int memberCount;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onInvite;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Material(
      color: isSelected ? colors.bgTertiary : Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Row(
            children: [
              // 그룹 아이콘
              SvgPicture.asset(
                'assets/icons/ic_group.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  colors.iconPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),

              // 그룹 정보
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.body.copyWith(
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      memberCount > 1 ? '$memberCount명 참여중' : '나만 사용중',
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // 체크 아이콘 (선택된 경우)
              if (isSelected) ...[
                SvgPicture.asset(
                  'assets/icons/ic_check.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    colors.iconAccent,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
              ],

              // 더보기 메뉴
              PopupMenuButton<String>(
                icon: SvgPicture.asset(
                  'assets/icons/ic_more_small.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    colors.iconSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mdAll,
                  side: BorderSide(color: colors.borderSecondary),
                ),
                color: colors.bgSecondary,
                elevation: 4,
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'invite') onInvite();
                  if (value == 'leave') onLeave();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    height: 48,
                    child: Text(
                      '그룹 이름 수정',
                      style: AppTypography.body.copyWith(color: colors.textPrimary),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'invite',
                    height: 48,
                    child: Text(
                      '그룹 초대하기',
                      style: AppTypography.body.copyWith(color: colors.textPrimary),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'leave',
                    height: 48,
                    child: Text(
                      '그룹 나가기',
                      style: AppTypography.body.copyWith(color: colors.statusError),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SvgMenuItem: SVG 아이콘을 사용하는 메뉴 아이템
class _SvgMenuItem extends StatelessWidget {
  const _SvgMenuItem({
    required this.iconPath,
    required this.label,
    this.iconSize = 24,
    this.iconColor,
    this.labelColor,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final double iconSize;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final textColor = labelColor ?? colors.textPrimary;
    final svgColor = iconColor ?? colors.iconPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: ColorFilter.mode(
                      svgColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// MenuItem: 메뉴 아이템
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.labelColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final textColor = labelColor ?? colors.textPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.smAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: colors.iconPrimary,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaveGroupDialog extends ConsumerStatefulWidget {
  final String groupCode;
  final String groupName;

  const _LeaveGroupDialog({
    required this.groupCode,
    required this.groupName,
  });

  @override
  ConsumerState<_LeaveGroupDialog> createState() => _LeaveGroupDialogState();
}

class _LeaveGroupDialogState extends ConsumerState<_LeaveGroupDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: '그룹 나가기',
      description: '"${widget.groupName}" 그룹에서 나가시겠습니까?\n그룹의 구독 내역이 삭제됩니다.',
      actions: [
        AppDialogAction(
          label: '취소',
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        AppDialogAction(
          label: _isLoading ? '처리중...' : '나가기',
          isPrimary: true,
          onPressed: _isLoading ? null : _onLeave,
        ),
      ],
    );
  }

  Future<void> _onLeave() async {
    setState(() => _isLoading = true);

    final leaveGroup = ref.read(leaveGroupUseCaseProvider);
    final groups = ref.read(homeViewModelProvider).groups;

    try {
      await leaveGroup(widget.groupCode);

      if (!mounted) return;
      Navigator.pop(context);

      // 다른 그룹이 있으면 전환, 없으면 null로 초기화
      final remainingGroups = groups.where((g) => g.code != widget.groupCode);
      final nextGroupCode = remainingGroups.isNotEmpty ? remainingGroups.first.code : null;
      ref.read(homeViewModelProvider.notifier).selectGroup(nextGroupCode);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

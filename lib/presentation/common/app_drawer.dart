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

    return Drawer(
      width: 300,
      backgroundColor: colors.bgSecondary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s6,
          ),
          child: Column(
            children: [
              // ProfileSection
              _ProfileSection(
                onEditNicknameTap: () => _showEditNicknameDialog(context, ref),
              ),

              const SizedBox(height: AppSpacing.s6),
              const AppDivider(),
              const SizedBox(height: AppSpacing.s6),

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
                  onGroupLeave: (groupCode, groupName) =>
                      _showLeaveGroupDialog(context, ref, groupCode, groupName),
                ),
              ),

              const AppDivider(),
              const SizedBox(height: AppSpacing.s6),

              // GroupAddItem
              _MenuItem(
                icon: Icons.add,
                label: '그룹 추가',
                labelColor: colors.textSecondary,
                onTap: () => _showCreateGroupDialog(context, ref),
              ),

              const SizedBox(height: AppSpacing.s6),
              const AppDivider(),
              const SizedBox(height: AppSpacing.s6),

              // MenuItems
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

  Future<void> _showCreateGroupDialog(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final createGroup = ref.read(createGroupUseCaseProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    Navigator.pop(context);

    final groupName = await showAppTextInputDialog(
      context: context,
      title: '새 그룹 만들기',
      hint: '예: 가족 구독, 친구들',
      maxLength: 10,
      confirmLabel: '만들기',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '그룹 이름을 입력해주세요';
        }
        return null;
      },
    );

    if (groupName != null) {
      try {
        final groupCode = await createGroup(groupName);
        homeViewModel.selectGroup(groupCode);
      } on Exception catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
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
            width: 24,
            height: 24,
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
    required this.onGroupLeave,
  });

  final List<dynamic> groups;
  final String? selectedGroupCode;
  final void Function(String) onGroupTap;
  final void Function(String, String) onGroupEdit;
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
    required this.onLeave,
  });

  final String name;
  final int memberCount;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
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
              Icon(
                memberCount > 1 ? Icons.group_outlined : Icons.person_outline,
                size: 24,
                color: colors.iconPrimary,
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

              // 공유 아이콘 (selected 시)
              if (isSelected) ...[
                GestureDetector(
                  onTap: () {
                    // TODO: 공유 기능
                  },
                  child: Icon(
                    Icons.share_outlined,
                    size: 24,
                    color: colors.iconSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
              ],

              // 더보기 메뉴
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 24,
                  color: colors.iconSecondary,
                ),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'leave') onLeave();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20, color: colors.iconPrimary),
                        const SizedBox(width: AppSpacing.s2),
                        Text('이름 변경', style: AppTypography.body.copyWith(color: colors.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'leave',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: colors.statusError),
                        const SizedBox(width: AppSpacing.s2),
                        Text('나가기', style: AppTypography.body.copyWith(color: colors.statusError)),
                      ],
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
      description: '"${widget.groupName}" 그룹에서 나가시겠습니까?\n\n그룹의 구독 내역이 삭제됩니다.',
      actions: [
        AppDialogAction(
          label: '취소',
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        AppDialogAction(
          label: _isLoading ? '처리중...' : '나가기',
          isPrimary: true,
          isDestructive: true,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/auth/login_screen.dart';
import 'package:subby/presentation/home/home_view_model.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Padding(
              padding: EdgeInsets.all(AppSpacing.s4),
              child: Text(
                '구독 그룹',
                style: AppTypography.headline.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),

            // 그룹 목록
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s2),
                children: [
                  // 모든 그룹 표시 (기본 그룹 포함)
                  ...state.groups.map((group) => _GroupTile(
                        title: group.effectiveName,
                        subtitle: group.members.length > 1
                            ? '${group.members.length}명 참여'
                            : '나만 사용',
                        icon: group.members.length > 1
                            ? Icons.group_outlined
                            : Icons.person_outline,
                        isSelected: state.selectedGroupCode == group.code,
                        onTap: () {
                          ref
                              .read(homeViewModelProvider.notifier)
                              .selectGroup(group.code);
                          Navigator.pop(context);
                        },
                        onEdit: () => _showRenameGroupDialog(
                          context,
                          ref,
                          group.code,
                          group.effectiveName,
                        ),
                        onLeave: () => _showLeaveGroupDialog(
                          context,
                          ref,
                          group.code,
                          group.effectiveName,
                        ),
                      )),

                  // 그룹이 없는 경우
                  if (state.groups.isEmpty && !state.isLoading)
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.s4),
                      child: Text(
                        '참여 중인 그룹이 없습니다',
                        style: AppTypography.body.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  // 초기 로딩 중
                  if (state.groups.isEmpty && state.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.s4),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),

            // 하단 버튼들
            Container(
              color: colorScheme.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.s4),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showCreateGroupDialog(context, ref),
                            icon: const Icon(Icons.add),
                            label: const Text('새 그룹 만들기'),
                          ),
                        ),
                        SizedBox(height: AppSpacing.s2),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showJoinGroupDialog(context, ref),
                            icon: const Icon(Icons.login),
                            label: const Text('그룹 참여하기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 계정 섹션
                  _buildAccountSection(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Future<void> _showJoinGroupDialog(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    final groupCode = await showAppTextInputDialog(
      context: context,
      title: '그룹 참여하기',
      hint: '12자리 그룹 코드 입력',
      maxLength: 12,
      confirmLabel: '확인',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '그룹 코드를 입력해주세요';
        }

        final code = value.trim().toUpperCase();

        if (code.length != 12) {
          return '12자리 코드를 입력해주세요';
        }
        if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
          return '영문 대문자와 숫자만 입력해주세요';
        }

        return null;
      },
    );

    if (groupCode == null) return;

    final code = groupCode.trim().toUpperCase();

    showJoinGroupDialog(
      context: navigator.context,
      groupCode: code,
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

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    final isAnonymous = ref.watch(isAnonymousProvider).valueOrNull ?? true;
    final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
    final email = authDataSource.currentEmail;
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    if (isAnonymous) {
      // 익명 상태 - 백업 유도 배너
      return Container(
        margin: EdgeInsets.fromLTRB(AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s4),
        decoration: BoxDecoration(
          color: colors.statusWarning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.statusWarning.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s3),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: colors.statusWarning, size: 24),
                SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '백업되지 않음',
                        style: AppTypography.title.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '로그인하여 데이터 보호하기',
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      );
    } else {
      // 로그인 상태 - 계정 정보 표시
      return Container(
        margin: EdgeInsets.fromLTRB(AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s4),
        padding: EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: colors.statusSuccess.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: colors.statusSuccess, size: 24),
            SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                email ?? '로그인됨',
                style: AppTypography.body.copyWith(
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => _showSignOutDialog(context, ref),
              child: Text(
                '로그아웃',
                style: AppTypography.caption.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃하면 이 기기의 데이터가 삭제됩니다.\n계속하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
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
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onLeave;

  const _GroupTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colors.bgAccent : colors.textPrimary,
      ),
      title: Text(
        title,
        style: (isSelected ? AppTypography.title : AppTypography.bodyLarge)
            .copyWith(color: isSelected ? colors.bgAccent : colors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.caption.copyWith(color: colors.textTertiary),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) {
          if (value == 'edit') onEdit();
          if (value == 'leave') onLeave();
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 20),
                SizedBox(width: AppSpacing.s2),
                Text('이름 변경'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'leave',
            child: Row(
              children: [
                Icon(Icons.logout, size: 20, color: Colors.red),
                SizedBox(width: AppSpacing.s2),
                Text('나가기', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      selected: isSelected,
      selectedTileColor: colors.tabSelectedBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
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
    return AlertDialog(
      title: const Text('그룹 나가기'),
      content: Text('"${widget.groupName}" 그룹에서 나가시겠습니까?\n\n그룹의 구독 내역이 삭제됩니다.'),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _onLeave,
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('나가기'),
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

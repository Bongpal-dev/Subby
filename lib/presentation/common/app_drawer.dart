import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
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
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                '구독 그룹',
                style: AppTypography.headlineLarge.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),

            // 그룹 목록
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
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

                  // 그룹이 없는 경우 (초기화 중)
                  if (state.groups.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),

            // 하단 버튼들
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
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
                  SizedBox(height: AppSpacing.sm),
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
        color: isSelected ? colors.primary : colors.textPrimary,
      ),
      title: Text(
        title,
        style: (isSelected ? AppTypography.titleLarge : AppTypography.bodyLarge)
            .copyWith(color: isSelected ? colors.primary : colors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.captionLarge.copyWith(color: colors.textTertiary),
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
                SizedBox(width: AppSpacing.sm),
                Text('이름 변경'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'leave',
            child: Row(
              children: [
                Icon(Icons.logout, size: 20, color: Colors.red),
                SizedBox(width: AppSpacing.sm),
                Text('나가기', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
      selected: isSelected,
      selectedTileColor: colors.selectedBg,
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

      // 다른 그룹이 있으면 전환, 없으면 null
      final remainingGroups = groups.where((g) => g.code != widget.groupCode);
      if (remainingGroups.isNotEmpty) {
        ref.read(homeViewModelProvider.notifier).selectGroup(remainingGroups.first.code);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

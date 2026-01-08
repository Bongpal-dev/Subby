import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/home/home_view_model.dart';

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
              padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                      padding: EdgeInsets.all(16),
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
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 8),
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

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => const _CreateGroupDialog(),
    );
  }

  void _showJoinGroupDialog(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    // TODO: 그룹 참여 다이얼로그
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('그룹 참여 기능 준비 중')),
    );
  }

  void _showRenameGroupDialog(
    BuildContext context,
    WidgetRef ref,
    String groupCode,
    String currentName,
  ) {
    showDialog(
      context: context,
      builder: (context) => _RenameGroupDialog(
        groupCode: groupCode,
        currentName: currentName,
      ),
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
                SizedBox(width: 8),
                Text('이름 변경'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'leave',
            child: Row(
              children: [
                Icon(Icons.logout, size: 20, color: Colors.red),
                SizedBox(width: 8),
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

class _CreateGroupDialog extends ConsumerStatefulWidget {
  const _CreateGroupDialog();

  @override
  ConsumerState<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends ConsumerState<_CreateGroupDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새 그룹 만들기'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller,
                autofocus: true,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: '그룹 이름',
                  hintText: '예: 가족 구독, 친구들',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                  errorText: _errorMessage,
                ),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '그룹 이름을 입력해주세요';
                  }
                  if (value.length >= 10) {
                    return '최대 10자까지 입력 가능합니다';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _onCreate,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('만들기'),
        ),
      ],
    );
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final groupName = _controller.text.trim();
    final createGroup = ref.read(createGroupUseCaseProvider);

    try {
      final groupCode = await createGroup(groupName);

      if (!mounted) return;
      Navigator.pop(context);

      ref.read(homeViewModelProvider.notifier).selectGroup(groupCode);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }
}

class _RenameGroupDialog extends ConsumerStatefulWidget {
  final String groupCode;
  final String currentName;

  const _RenameGroupDialog({
    required this.groupCode,
    required this.currentName,
  });

  @override
  ConsumerState<_RenameGroupDialog> createState() => _RenameGroupDialogState();
}

class _RenameGroupDialogState extends ConsumerState<_RenameGroupDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('그룹 이름 변경'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '그룹 이름',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '그룹 이름을 입력해주세요';
                  }
                  if (value.length >= 10) {
                    return '최대 10자까지 입력 가능합니다';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _onSave,
          child: const Text('저장'),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _controller.text.trim();
    final groupRepository = ref.read(groupRepositoryProvider);

    await groupRepository.updateDisplayName(widget.groupCode, newName);

    if (!mounted) return;
    Navigator.pop(context);
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

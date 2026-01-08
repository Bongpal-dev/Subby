import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                        title: group.name,
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
}

class _GroupTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      subtitle: Text(subtitle),
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withValues(alpha: 0.1),
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

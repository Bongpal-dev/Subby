import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  // 내 구독 (개인)
                  _GroupTile(
                    title: '내 구독',
                    subtitle: '개인 구독 목록',
                    icon: Icons.person_outline,
                    isSelected: state.selectedGroupCode == null,
                    onTap: () {
                      ref.read(homeViewModelProvider.notifier).selectGroup(null);
                      Navigator.pop(context);
                    },
                  ),

                  // 그룹 목록
                  if (state.groups.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        '다른 그룹',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...state.groups.map((group) => _GroupTile(
                          title: group.name,
                          subtitle: '${group.members.length}명 참여',
                          icon: Icons.group_outlined,
                          isSelected: state.selectedGroupCode == group.code,
                          onTap: () {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .selectGroup(group.code);
                            Navigator.pop(context);
                          },
                        )),
                  ],
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
    // TODO: 그룹 생성 다이얼로그
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('그룹 만들기 기능 준비 중')),
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

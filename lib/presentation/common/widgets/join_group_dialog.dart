import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/usecase/join_group_usecase.dart';
import 'package:subby/presentation/home/home_view_model.dart';

class JoinGroupDialog extends ConsumerStatefulWidget {
  final String groupCode;
  final String groupName;
  final int memberCount;

  const JoinGroupDialog({
    super.key,
    required this.groupCode,
    required this.groupName,
    required this.memberCount,
  });

  @override
  ConsumerState<JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends ConsumerState<JoinGroupDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('그룹 참여하기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"${widget.groupName}" 그룹에 참여하시겠습니까?'),
          const SizedBox(height: 8),
          Text(
            '멤버: ${widget.memberCount}명',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _onJoin,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('참여'),
        ),
      ],
    );
  }

  Future<void> _onJoin() async {
    setState(() => _isLoading = true);

    final joinGroup = ref.read(joinGroupUseCaseProvider);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final result = await joinGroup(widget.groupCode);

      if (!mounted) return;

      switch (result) {
        case JoinGroupResult.success:
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('"${widget.groupName}" 그룹에 참여했습니다')),
          );
          ref.read(homeViewModelProvider.notifier).selectGroup(widget.groupCode);
          Navigator.pop(context, true);
          break;

        case JoinGroupResult.alreadyJoined:
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('이미 참여 중인 그룹입니다')),
          );
          Navigator.pop(context, false);
          break;

        case JoinGroupResult.notFound:
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('존재하지 않는 그룹입니다')),
          );
          Navigator.pop(context, false);
          break;
      }
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

Future<bool?> showJoinGroupDialog({
  required BuildContext context,
  required String groupCode,
  required String groupName,
  required int memberCount,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => JoinGroupDialog(
      groupCode: groupCode,
      groupName: groupName,
      memberCount: memberCount,
    ),
  );
}

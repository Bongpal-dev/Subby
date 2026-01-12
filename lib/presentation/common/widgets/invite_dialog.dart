import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:subby/core/util/invite_link_generator.dart';

class InviteDialog extends StatelessWidget {
  final String groupCode;
  final String groupName;

  const InviteDialog({
    super.key,
    required this.groupCode,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('그룹 초대하기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '아래 코드를 공유하여\n"$groupName" 그룹에 초대하세요',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              groupCode,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _copyCode(context),
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('코드 복사하기'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _shareCode(context),
              icon: const Icon(Icons.share, size: 18),
              label: const Text('공유하기'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: groupCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('초대 코드가 복사되었습니다')),
    );
  }

  void _shareCode(BuildContext context) {
    final inviteLink = InviteLinkGenerator.generate(groupCode);
    Share.share(
      '$groupName 그룹에 초대합니다!\n\n초대 코드: $groupCode\n\n앱에서 참여하기: $inviteLink',
      subject: 'Subby 그룹 초대',
    );
  }
}

Future<void> showInviteDialog({
  required BuildContext context,
  required String groupCode,
  required String groupName,
}) {
  return showDialog(
    context: context,
    builder: (context) => InviteDialog(
      groupCode: groupCode,
      groupName: groupName,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/domain/model/sync_event.dart';
import 'package:subby/presentation/common/providers/sync_notification_provider.dart';

/// 동기화 이벤트를 감지하고 스낵바를 표시하는 위젯
class SyncNotificationListener extends ConsumerWidget {
  final Widget child;

  const SyncNotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SyncEvent>>(syncEventStreamProvider, (previous, next) {
      next.whenData((event) {
        if (event.hasChanges) {
          _showSyncSnackBar(context, event);
        }
      });
    });

    return child;
  }

  void _showSyncSnackBar(BuildContext context, SyncEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.sync, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(event.message),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

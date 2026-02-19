import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/domain/model/sync_event.dart';
import 'package:subby/presentation/common/providers/sync_notification_provider.dart';

/// 동기화 이벤트를 감지하는 위젯 (알림은 FCM에서 처리)
class SyncNotificationListener extends ConsumerWidget {
  final Widget child;

  const SyncNotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SyncEvent 구독 유지 (로컬 데이터 갱신 감지용)
    ref.listen<AsyncValue<SyncEvent>>(syncEventStreamProvider, (previous, next) {});

    return child;
  }
}

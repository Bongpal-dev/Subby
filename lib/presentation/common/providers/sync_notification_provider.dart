import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/data/service_providers.dart';
import 'package:subby/domain/model/sync_event.dart';

/// 동기화 이벤트 스트림 Provider
final syncEventStreamProvider = StreamProvider<SyncEvent>((ref) {
  final syncService = ref.watch(realtimeSyncServiceProvider);

  return syncService.syncEventStream;
});

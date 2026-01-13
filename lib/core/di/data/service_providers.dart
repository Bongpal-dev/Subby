import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/data/datasource_providers.dart';
import 'package:subby/data/service/realtime_sync_service.dart';

final realtimeSyncServiceProvider = Provider<RealtimeSyncService>((ref) {
  final remoteDataSource = ref.watch(subscriptionRemoteDataSourceProvider);
  final localDataSource = ref.watch(subscriptionLocalDataSourceProvider);

  return RealtimeSyncService(remoteDataSource, localDataSource);
});

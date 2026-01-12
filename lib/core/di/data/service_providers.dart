import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/data/datasource_providers.dart';
import 'package:subby/data/service/connectivity_service.dart';
import 'package:subby/data/service/realtime_sync_service.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final connectivity = ref.watch(connectivityProvider);

  return ConnectivityService(connectivity);
});

final realtimeSyncServiceProvider = Provider<RealtimeSyncService>((ref) {
  final remoteDataSource = ref.watch(subscriptionRemoteDataSourceProvider);
  final localDataSource = ref.watch(subscriptionLocalDataSourceProvider);

  return RealtimeSyncService(remoteDataSource, localDataSource);
});

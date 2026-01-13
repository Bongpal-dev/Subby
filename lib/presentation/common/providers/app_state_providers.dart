import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/core/di/data/service_providers.dart';

final authStateProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.valueOrNull;
});

final appInitializedProvider = FutureProvider<String>((ref) async {
  final initializeApp = ref.watch(initializeAppUseCaseProvider);

  return initializeApp();
});

final currentGroupCodeProvider = StateProvider<String?>((ref) {
  final appInit = ref.watch(appInitializedProvider);

  return appInit.valueOrNull;
});

final currentGroupProvider = StreamProvider((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);

  if (groupCode == null) return const Stream.empty();

  final groupRepository = ref.watch(groupRepositoryProvider);

  return groupRepository.watchByCode(groupCode);
});

final realtimeSyncProvider = Provider<void>((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);

  if (groupCode == null) return;

  final syncService = ref.read(realtimeSyncServiceProvider);
  syncService.startSync(groupCode);
});

final pendingSyncProvider = Provider<void>((ref) {
  final processPendingChanges = ref.read(processPendingChangesUseCaseProvider);

  processPendingChanges();

  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    processPendingChanges();
  });

  ref.onDispose(() {
    timer.cancel();
  });
});

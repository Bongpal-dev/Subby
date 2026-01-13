import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/core/di/data/service_providers.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/presentation/common/providers/conflict_state_provider.dart';

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

final pendingSyncTriggerProvider = StateProvider<int>((ref) => 0);

final pendingSyncProvider = Provider<void>((ref) {
  final processPendingChanges = ref.read(processPendingChangesUseCaseProvider);
  final conflictNotifier = ref.read(conflictStateProvider.notifier);

  Future<ConflictResolution?> onConflict(conflict) async {
    final completer = Completer<ConflictResolution>();

    conflictNotifier.setConflict(conflict, (resolution) {
      completer.complete(resolution);
    });

    return completer.future;
  }

  // 데이터 변동 시 트리거
  ref.watch(pendingSyncTriggerProvider);

  // 앱 시작 시 1회 실행
  processPendingChanges(onConflict: onConflict);

  // 네트워크 상태 변경 감지
  bool wasOffline = false;
  final subscription = Connectivity().onConnectivityChanged.listen((result) {
    final isOffline = result.contains(ConnectivityResult.none);

    if (wasOffline && !isOffline) {
      print('[Conflict] Network restored, triggering pending sync');
      processPendingChanges(onConflict: onConflict);
    }

    wasOffline = isOffline;
  });

  ref.onDispose(() {
    subscription.cancel();
  });
});

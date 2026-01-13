import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_conflict.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';
import 'package:subby/domain/usecase/detect_subscription_conflict_usecase.dart';

typedef ConflictResolver = Future<ConflictResolution?> Function(
  SubscriptionConflict conflict,
);

class ProcessPendingChangesUseCase {
  final PendingChangeRepository _pendingChangeRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;
  final AuthRepository _authRepository;
  final DetectSubscriptionConflictUseCase _detectConflict;

  ProcessPendingChangesUseCase(
    this._pendingChangeRepository,
    this._groupRepository,
    this._subscriptionRepository,
    this._authRepository,
    this._detectConflict,
  );

  Future<void> call({ConflictResolver? onConflict}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult.contains(ConnectivityResult.none);

    if (isOffline) return;

    await _processGroupChanges();
    await _processSubscriptionChanges(onConflict);
  }

  Future<void> _processGroupChanges() async {
    final groupChanges = await _pendingChangeRepository.getGroupChanges();

    for (final (change, group) in groupChanges) {
      try {
        switch (change.action) {
          case ChangeAction.create:
            if (group != null) await _groupRepository.syncCreate(group);
          case ChangeAction.update:
            if (group != null) await _groupRepository.syncUpdate(group);
          case ChangeAction.delete:
            final userId = _authRepository.currentUserId!;
            await _groupRepository.syncLeave(change.entityId, userId);
        }

        await _pendingChangeRepository.delete(change.entityId);
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _processSubscriptionChanges(ConflictResolver? onConflict) async {
    final subscriptionChanges =
        await _pendingChangeRepository.getSubscriptionChanges();

    if (subscriptionChanges.isEmpty) return;

    final groupCodes =
        subscriptionChanges.map((e) => e.$2?.groupCode).whereType<String>().toSet();

    final serverSubscriptions = <String, List<UserSubscription>>{};

    for (final groupCode in groupCodes) {
      serverSubscriptions[groupCode] =
          await _subscriptionRepository.fetchRemoteByGroupCode(groupCode);
    }

    for (final (change, subscription) in subscriptionChanges) {
      if (subscription == null) continue;

      try {
        switch (change.action) {
          case ChangeAction.create:
            await _subscriptionRepository.syncCreate(subscription);

          case ChangeAction.update:
            final serverList = serverSubscriptions[subscription.groupCode] ?? [];
            final conflict = _detectConflict(subscription, serverList);

            if (conflict != null && _hasTimestampConflict(change, conflict)) {
              if (onConflict == null) continue;

              final resolution = await onConflict(conflict);

              if (resolution == null) continue;

              await _resolveConflict(resolution, subscription, conflict);
            } else {
              await _subscriptionRepository.syncUpdate(subscription);
            }

          case ChangeAction.delete:
            await _subscriptionRepository.syncDelete(
              subscription.groupCode,
              change.entityId,
            );
        }

        await _pendingChangeRepository.delete(change.entityId);
      } catch (e) {
        continue;
      }
    }
  }

  bool _hasTimestampConflict(PendingChange change, SubscriptionConflict conflict) {
    final serverUpdatedAt = conflict.serverSubscription.updatedAt;

    if (serverUpdatedAt == null) return false;

    return serverUpdatedAt.isAfter(change.createdAt);
  }

  Future<void> _resolveConflict(
    ConflictResolution resolution,
    UserSubscription localSubscription,
    SubscriptionConflict conflict,
  ) async {
    switch (resolution) {
      case ConflictResolution.keepLocal:
        await _subscriptionRepository.syncUpdate(localSubscription);

      case ConflictResolution.useServer:
        await _subscriptionRepository.update(conflict.serverSubscription);
    }
  }
}

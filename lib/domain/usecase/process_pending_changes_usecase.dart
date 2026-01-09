import 'dart:convert';

import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class ProcessPendingChangesUseCase {
  final PendingChangeRepository _pendingChangeRepository;
  final GroupRepository _groupRepository;

  ProcessPendingChangesUseCase(
    this._pendingChangeRepository,
    this._groupRepository,
  );

  Future<void> call() async {
    final pendingChanges = await _pendingChangeRepository.getAll();

    for (final change in pendingChanges) {
      try {
        await _processChange(change);
        await _pendingChangeRepository.delete(change.entityId);
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _processChange(PendingChange change) async {
    switch (change.entityType) {
      case EntityType.subscription:
        // TODO: 구독 Firebase 연동 후 구현
        break;
      case EntityType.group:
        await _processGroupChange(change);
    }
  }

  Future<void> _processGroupChange(PendingChange change) async {
    final json = jsonDecode(change.payload) as Map<String, dynamic>;

    switch (change.action) {
      case ChangeAction.create:
        final group = SubscriptionGroup.fromJson(json);
        await _groupRepository.syncCreate(group);
      case ChangeAction.update:
        final group = SubscriptionGroup.fromJson(json);
        await _groupRepository.syncUpdate(group);
      case ChangeAction.delete:
        final userId = json['userId'] as String;
        await _groupRepository.syncLeave(change.entityId, userId);
    }
  }
}

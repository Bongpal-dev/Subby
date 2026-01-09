import 'dart:convert';

import 'package:subby/core/error/firebase_sync_exception.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class LeaveGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;
  final PendingChangeRepository _pendingChangeRepository;

  LeaveGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required SubscriptionRepository subscriptionRepository,
    required PendingChangeRepository pendingChangeRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _subscriptionRepository = subscriptionRepository,
        _pendingChangeRepository = pendingChangeRepository;

  Future<void> call(String groupCode) async {
    final userId = _authRepository.currentUserId!;

    await _subscriptionRepository.deleteByGroupCode(groupCode);

    try {
      await _groupRepository.leaveGroup(groupCode, userId);
    } on FirebaseSyncException {
      await _pendingChangeRepository.save(
        PendingChange(
          entityId: groupCode,
          entityType: EntityType.group,
          action: ChangeAction.delete,
          payload: jsonEncode({'userId': userId}),
          createdAt: DateTime.now(),
        ),
      );
    }
  }
}

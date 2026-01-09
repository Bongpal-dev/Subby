import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class ProcessPendingChangesUseCase {
  final PendingChangeRepository _pendingChangeRepository;
  final GroupRepository _groupRepository;
  final AuthRepository _authRepository;

  ProcessPendingChangesUseCase(
    this._pendingChangeRepository,
    this._groupRepository,
    this._authRepository,
  );

  Future<void> call() async {
    await _processGroupChanges();
    // TODO: _processSubscriptionChanges() 구독 Firebase 연동 후 구현
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
}

import 'package:subby/core/error/firebase_sync_exception.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class DeleteSubscriptionUseCase {
  final SubscriptionRepository _repository;
  final PendingChangeRepository _pendingChangeRepository;

  DeleteSubscriptionUseCase(this._repository, this._pendingChangeRepository);

  Future<void> call(String id) async {
    final subscription = await _repository.getById(id);
    if (subscription == null) return;

    try {
      await _repository.delete(id);
    } on FirebaseSyncException {
      await _pendingChangeRepository.saveSubscriptionChange(
        subscription,
        ChangeAction.delete,
      );
    }
  }
}

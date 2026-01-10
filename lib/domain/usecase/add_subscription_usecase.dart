import 'package:subby/core/error/firebase_sync_exception.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;
  final PendingChangeRepository _pendingChangeRepository;

  AddSubscriptionUseCase(this._repository, this._pendingChangeRepository);

  Future<void> call(UserSubscription subscription) async {
    try {
      await _repository.create(subscription);
    } on FirebaseSyncException {
      await _pendingChangeRepository.saveSubscriptionChange(
        subscription,
        ChangeAction.create,
      );
    }
  }
}

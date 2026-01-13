import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;
  final PendingChangeRepository _pendingChangeRepository;

  AddSubscriptionUseCase(this._repository, this._pendingChangeRepository);

  Future<void> call(UserSubscription subscription) async {
    await _repository.create(subscription);
    await _pendingChangeRepository.saveSubscriptionChange(
      subscription,
      ChangeAction.create,
    );
  }
}

import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;

  AddSubscriptionUseCase(this._repository);

  Future<void> call(UserSubscription subscription) => _repository.insert(subscription);
}

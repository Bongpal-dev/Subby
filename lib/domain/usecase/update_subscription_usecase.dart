import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class UpdateSubscriptionUseCase {
  final SubscriptionRepository _repository;

  UpdateSubscriptionUseCase(this._repository);

  Future<void> call(UserSubscription subscription) => _repository.update(subscription);
}

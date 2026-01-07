import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class GetSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionsUseCase(this._repository);

  Future<List<UserSubscription>> call() => _repository.getAll();
}

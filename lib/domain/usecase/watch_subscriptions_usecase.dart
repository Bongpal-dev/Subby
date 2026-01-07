import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class WatchSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  WatchSubscriptionsUseCase(this._repository);

  Stream<List<UserSubscription>> call() => _repository.watchAll();
}

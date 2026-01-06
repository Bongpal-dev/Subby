import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/repository/subscription_repository.dart';

class WatchSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  WatchSubscriptionsUseCase(this._repository);

  Stream<List<Subscription>> call() => _repository.watchAll();
}

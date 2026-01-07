import 'package:subby/domain/model/subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class WatchSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  WatchSubscriptionsUseCase(this._repository);

  Stream<List<Subscription>> call() => _repository.watchAll();
}

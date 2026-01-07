import 'package:subby/domain/model/subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class GetSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionsUseCase(this._repository);

  Future<List<Subscription>> call() => _repository.getAll();
}

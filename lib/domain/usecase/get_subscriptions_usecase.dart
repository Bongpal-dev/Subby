import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/repository/subscription_repository.dart';

class GetSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionsUseCase(this._repository);

  Future<List<Subscription>> call() => _repository.getAll();
}

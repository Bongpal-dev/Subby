import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/repository/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;

  AddSubscriptionUseCase(this._repository);

  Future<void> call(Subscription subscription) => _repository.insert(subscription);
}

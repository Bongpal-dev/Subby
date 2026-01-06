import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/repository/subscription_repository.dart';

class UpdateSubscriptionUseCase {
  final SubscriptionRepository _repository;

  UpdateSubscriptionUseCase(this._repository);

  Future<void> call(Subscription subscription) => _repository.update(subscription);
}

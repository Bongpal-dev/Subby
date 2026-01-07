import 'package:subby/domain/model/subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository _repository;

  AddSubscriptionUseCase(this._repository);

  Future<void> call(Subscription subscription) => _repository.insert(subscription);
}

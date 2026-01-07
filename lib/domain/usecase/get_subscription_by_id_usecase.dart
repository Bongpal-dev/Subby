import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class GetSubscriptionByIdUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionByIdUseCase(this._repository);

  Future<UserSubscription?> call(String id) => _repository.getById(id);
}

import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/repository/subscription_repository.dart';

class GetSubscriptionByIdUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionByIdUseCase(this._repository);

  Future<Subscription?> call(String id) => _repository.getById(id);
}

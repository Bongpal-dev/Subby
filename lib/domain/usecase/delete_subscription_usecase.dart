import 'package:bongpal/domain/repository/subscription_repository.dart';

class DeleteSubscriptionUseCase {
  final SubscriptionRepository _repository;

  DeleteSubscriptionUseCase(this._repository);

  Future<void> call(String id) => _repository.delete(id);
}

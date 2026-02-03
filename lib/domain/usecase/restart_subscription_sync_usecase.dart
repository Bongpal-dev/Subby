import 'package:subby/domain/repository/subscription_repository.dart';

class RestartSubscriptionSyncUseCase {
  final SubscriptionRepository _subscriptionRepository;

  RestartSubscriptionSyncUseCase({
    required SubscriptionRepository subscriptionRepository,
  }) : _subscriptionRepository = subscriptionRepository;

  void call(String groupCode) {
    _subscriptionRepository.stopRemoteSync();
    _subscriptionRepository.startRemoteSync(groupCode);
  }
}

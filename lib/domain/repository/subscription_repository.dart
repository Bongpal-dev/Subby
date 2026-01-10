import 'package:subby/domain/model/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<List<UserSubscription>> getAll();
  Future<UserSubscription?> getById(String id);
  Future<void> create(UserSubscription subscription);
  Future<void> update(UserSubscription subscription);
  Future<void> delete(String id);
  Future<void> deleteByGroupCode(String groupCode);
  Stream<List<UserSubscription>> watchAll();

  Future<void> syncCreate(UserSubscription subscription);
  Future<void> syncUpdate(UserSubscription subscription);
  Future<void> syncDelete(String groupCode, String subscriptionId);
}

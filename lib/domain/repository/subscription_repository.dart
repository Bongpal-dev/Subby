import 'package:subby/domain/model/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<List<UserSubscription>> getAll();
  Future<UserSubscription?> getById(String id);
  Future<void> insert(UserSubscription subscription);
  Future<void> update(UserSubscription subscription);
  Future<void> delete(String id);
  Stream<List<UserSubscription>> watchAll();
}

import 'package:bongpal/domain/model/subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getAll();
  Future<Subscription?> getById(String id);
  Future<void> insert(Subscription subscription);
  Future<void> update(Subscription subscription);
  Future<void> delete(String id);
  Stream<List<Subscription>> watchAll();
}

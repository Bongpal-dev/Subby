import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/model/user_subscription.dart';

abstract class PendingChangeRepository {
  Future<List<PendingChange>> getAll();
  Future<PendingChange?> getByEntityId(String entityId);
  Future<void> save(PendingChange change);
  Future<void> delete(String entityId);
  Future<void> deleteAll();

  Future<void> saveGroupChange(SubscriptionGroup group, ChangeAction action);
  Future<List<(PendingChange, SubscriptionGroup?)>> getGroupChanges();

  Future<void> saveSubscriptionChange(UserSubscription subscription, ChangeAction action);
  Future<List<(PendingChange, UserSubscription?)>> getSubscriptionChanges();
}

import 'package:subby/domain/model/subscription_group.dart';

abstract class GroupRepository {
  Future<List<SubscriptionGroup>> getAll();
  Future<SubscriptionGroup?> getByCode(String code);
  Future<bool> existsByName(String name);

  Future<void> create(SubscriptionGroup group);
  Future<void> update(SubscriptionGroup group);
  Future<void> leaveGroup(String code, String userId);
  Future<void> updateDisplayName(String code, String? displayName);

  Stream<List<SubscriptionGroup>> watchAll();
  Stream<SubscriptionGroup?> watchByCode(String code);

  Future<void> syncCreate(SubscriptionGroup group);
  Future<void> syncUpdate(SubscriptionGroup group);
  Future<void> syncLeave(String code, String userId);
}

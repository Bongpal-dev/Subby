import 'package:subby/data/datasource/pending_change_local_datasource.dart';
import 'package:subby/data/mapper/group_mapper.dart';
import 'package:subby/data/mapper/pending_change_mapper.dart';
import 'package:subby/data/mapper/subscription_mapper.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class PendingChangeRepositoryImpl implements PendingChangeRepository {
  final PendingChangeLocalDataSource _localDataSource;

  PendingChangeRepositoryImpl(this._localDataSource);

  @override
  Future<List<PendingChange>> getAll() async {
    final dtos = await _localDataSource.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<PendingChange?> getByEntityId(String entityId) async {
    final dto = await _localDataSource.getByEntityId(entityId);
    return dto?.toDomain();
  }

  @override
  Future<void> save(PendingChange change) async {
    final existing = await _localDataSource.getByEntityId(change.entityId);

    // 기존 pending이 있는 경우 특수 처리
    if (existing != null) {
      final existingAction = ChangeAction.values.firstWhere(
        (e) => e.name == existing.action,
      );

      // create → delete: pending에서 제거 (Firebase에 없으니까)
      if (existingAction == ChangeAction.create &&
          change.action == ChangeAction.delete) {
        await _localDataSource.delete(change.entityId);
        return;
      }

      // create → update: action은 create 유지, payload만 갱신
      if (existingAction == ChangeAction.create &&
          change.action == ChangeAction.update) {
        final updatedChange = change.copyWith(action: ChangeAction.create);
        await _localDataSource.upsert(updatedChange.toDto());
        return;
      }
    }

    // 그 외: 그대로 저장 (upsert)
    await _localDataSource.upsert(change.toDto());
  }

  @override
  Future<void> delete(String entityId) async {
    await _localDataSource.delete(entityId);
  }

  @override
  Future<void> deleteAll() async {
    await _localDataSource.deleteAll();
  }

  @override
  Future<void> saveGroupChange(
    SubscriptionGroup group,
    ChangeAction action,
  ) async {
    final dto = group.toDto();

    await _localDataSource.saveGroupChange(dto, action.name, group.code);
  }

  @override
  Future<List<(PendingChange, SubscriptionGroup?)>> getGroupChanges() async {
    final results = await _localDataSource.getGroupChanges();

    return results.map((tuple) {
      final change = tuple.$1.toDomain();
      final group = tuple.$2?.toDomain();
      return (change, group);
    }).toList();
  }

  @override
  Future<void> saveSubscriptionChange(
    UserSubscription subscription,
    ChangeAction action,
  ) async {
    final dto = subscription.toDto();

    await _localDataSource.saveSubscriptionChange(dto, action.name, subscription.id);
  }

  @override
  Future<List<(PendingChange, UserSubscription?)>> getSubscriptionChanges() async {
    final results = await _localDataSource.getSubscriptionChanges();

    return results.map((tuple) {
      final change = tuple.$1.toDomain();
      final subscription = tuple.$2?.toDomain();
      return (change, subscription);
    }).toList();
  }
}

import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/datasource/subscription_remote_datasource.dart';
import 'package:subby/data/mapper/subscription_mapper.dart';
import 'package:subby/data/service/realtime_sync_service.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource _localDataSource;
  final SubscriptionRemoteDataSource _remoteDataSource;
  final RealtimeSyncService _syncService;

  SubscriptionRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncService,
  );

  @override
  Future<List<UserSubscription>> getAll() async {
    final dtos = await _localDataSource.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<UserSubscription?> getById(String id) async {
    final dto = await _localDataSource.getById(id);
    return dto?.toDomain();
  }

  @override
  Future<void> create(UserSubscription subscription) async {
    final dto = subscription.toDto();
    await _localDataSource.insert(dto);
  }

  @override
  Future<void> update(UserSubscription subscription) async {
    final dto = subscription.toDto();
    await _localDataSource.update(dto);
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }

  @override
  Future<void> deleteByGroupCode(String groupCode) async {
    await _localDataSource.deleteByGroupCode(groupCode);
  }

  @override
  Stream<List<UserSubscription>> watchAll() {
    return _localDataSource.watchAll().map(
          (dtos) => dtos.map((e) => e.toDomain()).toList(),
        );
  }

  @override
  Future<void> syncCreate(UserSubscription subscription, {String? updatedBy}) async {
    await _remoteDataSource.saveSubscription(subscription.toDto(), updatedBy: updatedBy);
  }

  @override
  Future<void> syncUpdate(UserSubscription subscription, {String? updatedBy}) async {
    await _remoteDataSource.saveSubscription(subscription.toDto(), updatedBy: updatedBy);
  }

  @override
  Future<void> syncDelete(String groupCode, String subscriptionId, {String? updatedBy}) async {
    await _remoteDataSource.deleteSubscription(groupCode, subscriptionId, updatedBy: updatedBy);
  }

  @override
  Future<List<UserSubscription>> fetchRemoteByGroupCode(String groupCode) async {
    final dtos = await _remoteDataSource.fetchSubscriptions(groupCode);

    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> clearLocalData() async {
    await _localDataSource.deleteAll();
  }

  @override
  void startRemoteSync(String groupCode) {
    _syncService.startSync(groupCode);
  }

  @override
  void stopRemoteSync() {
    _syncService.stopSync();
  }
}

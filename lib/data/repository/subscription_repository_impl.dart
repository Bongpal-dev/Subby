import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/datasource/subscription_remote_datasource.dart';
import 'package:subby/data/mapper/subscription_mapper.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource _localDataSource;
  final SubscriptionRemoteDataSource _remoteDataSource;

  SubscriptionRepositoryImpl(this._localDataSource, this._remoteDataSource);

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
  Future<void> syncCreate(UserSubscription subscription) async {
    await _remoteDataSource.saveSubscription(subscription.toDto());
  }

  @override
  Future<void> syncUpdate(UserSubscription subscription) async {
    await _remoteDataSource.saveSubscription(subscription.toDto());
  }

  @override
  Future<void> syncDelete(String groupCode, String subscriptionId) async {
    await _remoteDataSource.deleteSubscription(groupCode, subscriptionId);
  }
}

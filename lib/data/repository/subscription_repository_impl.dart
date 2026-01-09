import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/mapper/subscription_mapper.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource _localDataSource;

  SubscriptionRepositoryImpl(this._localDataSource);

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
    await _localDataSource.insert(subscription.toDto());
  }

  @override
  Future<void> update(UserSubscription subscription) async {
    await _localDataSource.update(subscription.toDto());
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
}

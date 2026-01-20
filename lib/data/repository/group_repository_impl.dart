import 'package:subby/data/datasource/group_local_datasource.dart';
import 'package:subby/data/datasource/group_remote_datasource.dart';
import 'package:subby/data/mapper/group_mapper.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDataSource _localDataSource;
  final GroupRemoteDataSource _remoteDataSource;

  GroupRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<SubscriptionGroup>> getAll() async {
    final dtos = await _localDataSource.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<SubscriptionGroup?> getByCode(String code) async {
    final dto = await _localDataSource.getByCode(code);
    return dto?.toDomain();
  }

  @override
  Future<bool> existsByName(String name) async {
    return await _localDataSource.existsByName(name);
  }

  @override
  Future<void> create(SubscriptionGroup group) async {
    final dto = group.toDto();
    await _localDataSource.insert(dto);
  }

  @override
  Future<void> update(SubscriptionGroup group) async {
    final dto = group.toDto();
    await _localDataSource.update(dto);
  }

  @override
  Future<void> leaveGroup(String code, String userId) async {
    await _localDataSource.delete(code);
  }

  @override
  Future<void> updateDisplayName(String code, String? displayName) async {
    await _localDataSource.updateDisplayName(code, displayName);
  }

  @override
  Stream<List<SubscriptionGroup>> watchAll() {
    return _localDataSource.watchAll().map(
          (dtos) => dtos.map((e) => e.toDomain()).toList(),
        );
  }

  @override
  Stream<SubscriptionGroup?> watchByCode(String code) {
    return _localDataSource.watchByCode(code).map(
          (dto) => dto?.toDomain(),
        );
  }

  @override
  Future<void> syncCreate(SubscriptionGroup group) async {
    await _remoteDataSource.saveGroup(group.toDto());
  }

  @override
  Future<void> syncUpdate(SubscriptionGroup group) async {
    await _remoteDataSource.saveGroup(group.toDto());
  }

  @override
  Future<void> syncLeave(String code, String userId) async {
    await _remoteDataSource.leaveGroup(code, userId);
  }

  @override
  Future<SubscriptionGroup?> fetchRemoteByCode(String code) async {
    final dto = await _remoteDataSource.fetchGroup(code);
    return dto?.toDomain();
  }

  @override
  Future<void> joinGroup(String code, String userId) async {
    await _remoteDataSource.addMember(code, userId);

    final dto = await _remoteDataSource.fetchGroup(code);

    if (dto != null) {
      await _localDataSource.insert(dto);
    }
  }

  @override
  Future<void> saveToLocal(SubscriptionGroup group) async {
    final dto = group.toDto();
    await _localDataSource.insert(dto);
  }

  @override
  Future<List<SubscriptionGroup>> fetchRemoteGroupsByUserId(String userId) async {
    final dtos = await _remoteDataSource.fetchGroupsByUserId(userId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}

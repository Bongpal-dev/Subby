import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/datasource/group_remote_datasource.dart';
import 'package:subby/domain/model/subscription_group.dart' as domain;
import 'package:subby/domain/repository/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final AppDatabase _db;
  final GroupRemoteDataSource _remoteDataSource;

  GroupRepositoryImpl(this._db, this._remoteDataSource);

  @override
  Future<List<domain.SubscriptionGroup>> getAll() async {
    final rows = await _db.select(_db.subscriptionGroups).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<domain.SubscriptionGroup?> getByCode(String code) async {
    final row = await (_db.select(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<void> create(domain.SubscriptionGroup group) async {
    await _db.into(_db.subscriptionGroups).insert(_toCompanion(group));
    _remoteDataSource.saveGroup(group).catchError((_) {});
  }

  @override
  Future<void> update(domain.SubscriptionGroup group) async {
    await (_db.update(_db.subscriptionGroups)
          ..where((t) => t.code.equals(group.code)))
        .write(_toCompanion(group));
    _remoteDataSource.saveGroup(group).catchError((_) {});
  }

  @override
  Future<void> delete(String code) async {
    await (_db.delete(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .go();
    _remoteDataSource.deleteGroup(code).catchError((_) {});
  }

  @override
  Stream<List<domain.SubscriptionGroup>> watchAll() {
    return _db.select(_db.subscriptionGroups).watch().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  @override
  Stream<domain.SubscriptionGroup?> watchByCode(String code) {
    return (_db.select(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .watchSingleOrNull()
        .map((row) => row != null ? _toDomain(row) : null);
  }

  @override
  Future<bool> existsByName(String name) async {
    final row = await (_db.select(_db.subscriptionGroups)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> updateDisplayName(String code, String? displayName) async {
    await (_db.update(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .write(SubscriptionGroupsCompanion(
          displayName: Value(displayName),
        ));
  }

  domain.SubscriptionGroup _toDomain(SubscriptionGroup row) {
    return domain.SubscriptionGroup(
      code: row.code,
      name: row.name,
      displayName: row.displayName,
      ownerId: row.ownerId,
      members: [row.ownerId],
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  SubscriptionGroupsCompanion _toCompanion(domain.SubscriptionGroup group) {
    return SubscriptionGroupsCompanion.insert(
      code: group.code,
      name: group.name,
      displayName: Value(group.displayName),
      ownerId: group.ownerId,
      createdAt: group.createdAt,
      updatedAt: Value.absentIfNull(group.updatedAt),
    );
  }
}

import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/dto/group_dto.dart';

class GroupLocalDataSource {
  final AppDatabase _db;

  GroupLocalDataSource(this._db);

  Future<List<GroupDto>> getAll() async {
    final rows = await _db.select(_db.subscriptionGroups).get();

    return rows.map((e) => e.toDto()).toList();
  }

  Future<GroupDto?> getByCode(String code) async {
    final row = await (_db.select(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .getSingleOrNull();

    return row?.toDto();
  }

  Future<void> insert(GroupDto dto) async {
    await _db.into(_db.subscriptionGroups).insert(dto.toCompanion());
  }

  Future<void> update(GroupDto dto) async {
    await (_db.update(_db.subscriptionGroups)
          ..where((t) => t.code.equals(dto.code)))
        .write(dto.toCompanion());
  }

  Future<void> delete(String code) async {
    await (_db.delete(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .go();
  }

  Future<bool> existsByName(String name) async {
    final row = await (_db.select(_db.subscriptionGroups)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();

    return row != null;
  }

  Future<void> updateDisplayName(String code, String? displayName) async {
    await (_db.update(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .write(SubscriptionGroupsCompanion(
          displayName: Value(displayName),
        ));
  }

  Stream<List<GroupDto>> watchAll() {
    return _db.select(_db.subscriptionGroups).watch().map(
          (rows) => rows.map((e) => e.toDto()).toList(),
        );
  }

  Stream<GroupDto?> watchByCode(String code) {
    return (_db.select(_db.subscriptionGroups)
          ..where((t) => t.code.equals(code)))
        .watchSingleOrNull()
        .map((row) => row?.toDto());
  }
}

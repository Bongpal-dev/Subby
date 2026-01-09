import 'package:subby/data/database/database.dart';
import 'package:subby/data/dto/subscription_dto.dart';

class SubscriptionLocalDataSource {
  final AppDatabase _db;

  SubscriptionLocalDataSource(this._db);

  Future<List<SubscriptionDto>> getAll() async {
    final rows = await _db.select(_db.userSubscriptions).get();
    return rows.map((e) => e.toDto()).toList();
  }

  Future<SubscriptionDto?> getById(String id) async {
    final row = await (_db.select(_db.userSubscriptions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDto();
  }

  Future<void> insert(SubscriptionDto dto) async {
    await _db.into(_db.userSubscriptions).insert(dto.toCompanion());
  }

  Future<void> update(SubscriptionDto dto) async {
    await (_db.update(_db.userSubscriptions)
          ..where((t) => t.id.equals(dto.id)))
        .write(dto.toCompanion());
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.userSubscriptions)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> deleteByGroupCode(String groupCode) async {
    await (_db.delete(_db.userSubscriptions)
          ..where((t) => t.groupCode.equals(groupCode)))
        .go();
  }

  Stream<List<SubscriptionDto>> watchAll() {
    return _db.select(_db.userSubscriptions).watch().map(
          (rows) => rows.map((e) => e.toDto()).toList(),
        );
  }
}

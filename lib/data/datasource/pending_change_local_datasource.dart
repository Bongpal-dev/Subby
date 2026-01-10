import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/dto/group_dto.dart';
import 'package:subby/data/dto/pending_change_dto.dart';
import 'package:subby/data/dto/subscription_dto.dart';

class PendingChangeLocalDataSource {
  final AppDatabase _db;

  PendingChangeLocalDataSource(this._db);

  Future<List<PendingChangeDto>> getAll() async {
    final rows = await (_db.select(_db.pendingChanges)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map((e) => e.toDto()).toList();
  }

  Future<PendingChangeDto?> getByEntityId(String entityId) async {
    final row = await (_db.select(_db.pendingChanges)
          ..where((t) => t.entityId.equals(entityId)))
        .getSingleOrNull();
    return row?.toDto();
  }

  Future<void> upsert(PendingChangeDto dto) async {
    await _db.into(_db.pendingChanges).insertOnConflictUpdate(dto.toCompanion());
  }

  Future<void> delete(String entityId) async {
    await (_db.delete(_db.pendingChanges)
          ..where((t) => t.entityId.equals(entityId)))
        .go();
  }

  Future<void> deleteAll() async {
    await _db.delete(_db.pendingChanges).go();
  }

  Future<void> saveGroupChange(
    GroupDto dto,
    String action,
    String entityId,
  ) async {
    final pendingDto = PendingChangeDto(
      entityId: entityId,
      entityType: 'group',
      action: action,
      payload: jsonEncode(dto.toJson()),
      createdAt: DateTime.now(),
    );

    await upsert(pendingDto);
  }

  Future<List<(PendingChangeDto, GroupDto?)>> getGroupChanges() async {
    final rows = await (_db.select(_db.pendingChanges)
          ..where((t) => t.entityType.equals('group'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    return rows.map((row) {
      final changeDto = row.toDto();
      final groupDto = changeDto.payload.isNotEmpty
          ? GroupDto.fromJson(jsonDecode(changeDto.payload))
          : null;
      return (changeDto, groupDto);
    }).toList();
  }

  Future<void> saveSubscriptionChange(
    SubscriptionDto dto,
    String action,
    String entityId,
  ) async {
    final pendingDto = PendingChangeDto(
      entityId: entityId,
      entityType: 'subscription',
      action: action,
      payload: jsonEncode(dto.toJson()),
      createdAt: DateTime.now(),
    );

    await upsert(pendingDto);
  }

  Future<List<(PendingChangeDto, SubscriptionDto?)>> getSubscriptionChanges() async {
    final rows = await (_db.select(_db.pendingChanges)
          ..where((t) => t.entityType.equals('subscription'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    return rows.map((row) {
      final changeDto = row.toDto();
      final subscriptionDto = changeDto.payload.isNotEmpty
          ? SubscriptionDto.fromJson(jsonDecode(changeDto.payload))
          : null;
      return (changeDto, subscriptionDto);
    }).toList();
  }
}

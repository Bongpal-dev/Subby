import 'package:subby/data/database/database.dart';

class PendingChangeDto {
  final String entityId;
  final String entityType;
  final String action;
  final String payload;
  final DateTime createdAt;

  PendingChangeDto({
    required this.entityId,
    required this.entityType,
    required this.action,
    required this.payload,
    required this.createdAt,
  });
}

extension PendingChangeRowToDto on PendingChange {
  PendingChangeDto toDto() {
    return PendingChangeDto(
      entityId: entityId,
      entityType: entityType,
      action: action,
      payload: payload,
      createdAt: createdAt,
    );
  }
}

extension PendingChangeDtoToCompanion on PendingChangeDto {
  PendingChangesCompanion toCompanion() {
    return PendingChangesCompanion.insert(
      entityId: entityId,
      entityType: entityType,
      action: action,
      payload: payload,
      createdAt: createdAt,
    );
  }
}

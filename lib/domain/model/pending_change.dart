enum ChangeAction { create, update, delete }

enum EntityType { subscription, group }

class PendingChange {
  final String entityId;
  final EntityType entityType;
  final ChangeAction action;
  final String payload;
  final DateTime createdAt;

  PendingChange({
    required this.entityId,
    required this.entityType,
    required this.action,
    required this.payload,
    required this.createdAt,
  });

  PendingChange copyWith({
    String? entityId,
    EntityType? entityType,
    ChangeAction? action,
    String? payload,
    DateTime? createdAt,
  }) {
    return PendingChange(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

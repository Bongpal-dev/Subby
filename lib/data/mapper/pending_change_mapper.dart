import 'package:subby/data/dto/pending_change_dto.dart';
import 'package:subby/domain/model/pending_change.dart';

extension PendingChangeDtoToDomain on PendingChangeDto {
  PendingChange toDomain() {
    return PendingChange(
      entityId: entityId,
      entityType: EntityType.values.firstWhere((e) => e.name == entityType),
      action: ChangeAction.values.firstWhere((e) => e.name == action),
      payload: payload,
      createdAt: createdAt,
    );
  }
}

extension PendingChangeDomainToDto on PendingChange {
  PendingChangeDto toDto() {
    return PendingChangeDto(
      entityId: entityId,
      entityType: entityType.name,
      action: action.name,
      payload: payload,
      createdAt: createdAt,
    );
  }
}

import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';

class GroupDto {
  final String code;
  final String name;
  final String? displayName;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GroupDto({
    required this.code,
    required this.name,
    this.displayName,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
  });
}

extension SubscriptionGroupEntityToDto on SubscriptionGroup {
  GroupDto toDto() {
    return GroupDto(
      code: code,
      name: name,
      displayName: displayName,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension GroupDtoToCompanion on GroupDto {
  SubscriptionGroupsCompanion toCompanion() {
    return SubscriptionGroupsCompanion.insert(
      code: code,
      name: name,
      displayName: Value(displayName),
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: Value.absentIfNull(updatedAt),
    );
  }
}

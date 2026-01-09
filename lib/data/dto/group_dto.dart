import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';

class GroupDto {
  final String code;
  final String name;
  final String? displayName;
  final String ownerId;
  final List<String> members;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GroupDto({
    required this.code,
    required this.name,
    this.displayName,
    required this.ownerId,
    required this.members,
    required this.createdAt,
    this.updatedAt,
  });

  factory GroupDto.fromJson(Map<String, dynamic> json) {
    return GroupDto(
      code: json['code'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String?,
      ownerId: json['ownerId'] as String,
      members: List<String>.from(json['members'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'displayName': displayName,
      'ownerId': ownerId,
      'members': members,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}

extension SubscriptionGroupRowToDto on SubscriptionGroup {
  GroupDto toDto() {
    return GroupDto(
      code: code,
      name: name,
      displayName: displayName,
      ownerId: ownerId,
      members: [ownerId],
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

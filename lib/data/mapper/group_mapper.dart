import 'package:subby/data/dto/group_dto.dart';
import 'package:subby/data/response/group_response.dart';
import 'package:subby/domain/model/subscription_group.dart';

extension GroupResponseToDto on GroupResponse {
  GroupDto toDto() {
    return GroupDto(
      code: code,
      name: name,
      displayName: null,
      ownerId: ownerId,
      members: members,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: updatedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(updatedAt!)
          : null,
    );
  }
}

extension GroupDtoToDomain on GroupDto {
  SubscriptionGroup toDomain() {
    return SubscriptionGroup(
      code: code,
      name: name,
      displayName: displayName,
      ownerId: ownerId,
      members: members,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension SubscriptionGroupToDto on SubscriptionGroup {
  GroupDto toDto() {
    return GroupDto(
      code: code,
      name: name,
      displayName: displayName,
      ownerId: ownerId,
      members: members,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

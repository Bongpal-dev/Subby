import 'package:subby/data/dto/group_dto.dart';
import 'package:subby/domain/model/subscription_group.dart';

extension GroupDtoToDomain on GroupDto {
  SubscriptionGroup toDomain() {
    return SubscriptionGroup(
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

extension SubscriptionGroupToDto on SubscriptionGroup {
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

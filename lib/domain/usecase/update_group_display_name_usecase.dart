import 'package:subby/domain/repository/group_repository.dart';

/// 그룹 표시 이름 변경 UseCase
class UpdateGroupDisplayNameUseCase {
  final GroupRepository _groupRepository;

  UpdateGroupDisplayNameUseCase({
    required GroupRepository groupRepository,
  }) : _groupRepository = groupRepository;

  Future<void> call(String groupCode, String? displayName) async {
    await _groupRepository.updateDisplayName(groupCode, displayName);
  }
}

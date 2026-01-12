import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';

enum JoinGroupResult {
  success,
  alreadyJoined,
  notFound,
}

class JoinGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;

  JoinGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository;

  Future<JoinGroupResult> call(String groupCode) async {
    final userId = _authRepository.currentUserId;

    if (userId == null) {
      throw Exception('로그인이 필요합니다');
    }

    // 1. 로컬에서 이미 참여 중인지 확인
    final localGroup = await _groupRepository.getByCode(groupCode);

    if (localGroup != null) {
      return JoinGroupResult.alreadyJoined;
    }

    // 2. 원격에서 그룹 정보 조회
    final remoteGroup = await _groupRepository.fetchRemoteByCode(groupCode);

    if (remoteGroup == null) {
      return JoinGroupResult.notFound;
    }

    // 3. 이미 원격에서 멤버인 경우 (다른 기기에서 참여)
    if (remoteGroup.isMember(userId)) {
      // 로컬에 동기화만 수행
      await _groupRepository.create(remoteGroup);

      return JoinGroupResult.success;
    }

    // 4. 새로 참여
    await _groupRepository.joinGroup(groupCode, userId);

    return JoinGroupResult.success;
  }
}

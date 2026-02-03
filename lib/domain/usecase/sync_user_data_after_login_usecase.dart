import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';

class SyncUserDataAfterLoginUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  SyncUserDataAfterLoginUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _userRepository = userRepository;

  /// 로그인 후 데이터 동기화
  /// [previousUserId] 이전 익명 사용자 ID
  /// Returns: (연결된 그룹 수, 복구된 그룹 수)
  Future<({int linkedCount, int restoredCount})> call(String? previousUserId) async {
    final userId = _authRepository.currentUserId;
    if (userId == null) return (linkedCount: 0, restoredCount: 0);

    // 1. 로컬 그룹들의 익명 ID를 새 ID로 교체
    final localGroups = await _groupRepository.getAll();
    int linkedCount = 0;

    for (final group in localGroups) {
      final updatedMembers = group.members
          .where((id) => id != previousUserId)
          .toList();

      if (!updatedMembers.contains(userId)) {
        updatedMembers.add(userId);
      }

      final updatedGroup = group.copyWith(members: updatedMembers);
      await _groupRepository.update(updatedGroup);
      await _groupRepository.syncUpdate(updatedGroup);
      linkedCount++;
    }

    // 2. 원격에서 사용자 그룹 가져오기 (다른 기기에서 만든 그룹)
    final remoteGroups = await _groupRepository.fetchRemoteGroupsByUserId(userId);
    int restoredCount = 0;

    for (final remoteGroup in remoteGroups) {
      final existsLocally = localGroups.any((g) => g.code == remoteGroup.code);
      if (!existsLocally) {
        await _groupRepository.saveToLocal(remoteGroup);
        restoredCount++;
      }
    }

    final remoteNickname = await _userRepository.getNickname(userId);
    if (remoteNickname != null && remoteNickname.isNotEmpty) {
      await _userRepository.saveLocalNickname(remoteNickname);
    } else {
      final localNickname = await _userRepository.getLocalNickname();
      if (localNickname != null && localNickname.isNotEmpty) {
        await _userRepository.saveNickname(userId, localNickname);
      }
    }

    return (linkedCount: linkedCount, restoredCount: restoredCount);
  }
}

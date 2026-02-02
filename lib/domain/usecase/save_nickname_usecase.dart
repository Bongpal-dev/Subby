import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/nickname_repository.dart';

/// 닉네임 저장 UseCase
/// - 익명 사용자: 로컬에만 저장
/// - 로그인 사용자: 로컬 + 원격 + 그룹 동기화
class SaveNicknameUseCase {
  final AuthRepository _authRepository;
  final NicknameRepository _nicknameRepository;
  final GroupRepository _groupRepository;

  SaveNicknameUseCase({
    required AuthRepository authRepository,
    required NicknameRepository nicknameRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _nicknameRepository = nicknameRepository,
        _groupRepository = groupRepository;

  Future<void> call(String nickname) async {
    final userId = _authRepository.currentUserId;

    if (userId == null) {
      // 로컬에만 저장
      await _nicknameRepository.saveToLocal(nickname);
      return;
    }

    // 그룹 코드 목록 가져오기
    final groups = await _groupRepository.getAll();
    final groupCodes = groups.map((g) => g.code).toList();

    // 로컬 + 원격 + 그룹 동기화
    await _nicknameRepository.saveNickname(userId, nickname, groupCodes);
  }
}

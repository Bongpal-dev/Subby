import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/nickname_repository.dart';

/// 로그인 후 닉네임 동기화 UseCase
/// - 원격에 닉네임이 있으면 → 로컬에 저장 (원격 우선)
/// - 원격에 없고 로컬에 있으면 → 원격에 업로드
/// - 둘 다 없으면 → false 반환 (닉네임 설정 필요)
class SyncNicknameAfterLoginUseCase {
  final AuthRepository _authRepository;
  final NicknameRepository _nicknameRepository;

  SyncNicknameAfterLoginUseCase({
    required AuthRepository authRepository,
    required NicknameRepository nicknameRepository,
  })  : _authRepository = authRepository,
        _nicknameRepository = nicknameRepository;

  /// 닉네임 동기화 수행
  /// Returns: 닉네임이 존재하면 true, 없으면 false
  Future<bool> call() async {
    final userId = _authRepository.currentUserId;
    print('[Setup] SyncNickname userId: $userId');
    if (userId == null) return false;

    // 1. 원격 닉네임 조회
    final remoteNickname = await _nicknameRepository.getRemoteNickname(userId);
    print('[Setup] remoteNickname: $remoteNickname');

    // 2. 원격에 있으면 → 로컬에 저장 (대체)
    if (remoteNickname != null && remoteNickname.isNotEmpty) {
      await _nicknameRepository.saveToLocal(remoteNickname);
      print('[Setup] Saved remote to local');
      return true;
    }

    // 3. 원격에 없으면 → 로컬 확인
    final localNickname = await _nicknameRepository.getLocalNickname();
    print('[Setup] localNickname: $localNickname');

    if (localNickname != null && localNickname.isNotEmpty) {
      // 로컬에 있으면 → 원격에 업로드
      await _nicknameRepository.saveToRemote(userId, localNickname);
      print('[Setup] Uploaded local to remote');
      return true;
    }

    // 4. 둘 다 없음
    print('[Setup] No nickname found');
    return false;
  }
}

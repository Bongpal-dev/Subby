import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';

class GetCurrentNicknameUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  GetCurrentNicknameUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  Future<String?> call() async {
    final userId = _authRepository.currentUserId;
    if (userId == null) return null;

    // 로컬 먼저 확인
    final localNickname = await _userRepository.getLocalNickname();
    if (localNickname != null) return localNickname;

    // 원격에서 조회 후 로컬에 캐싱
    final remoteNickname = await _userRepository.getNickname(userId);
    if (remoteNickname != null) {
      await _userRepository.saveLocalNickname(remoteNickname);
    }
    return remoteNickname;
  }
}

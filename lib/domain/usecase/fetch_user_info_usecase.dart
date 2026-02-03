import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';

class FetchUserInfoUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  FetchUserInfoUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  Future<bool> call() async {
    final userId = _authRepository.currentUserId;
    if (userId == null) return false;

    final remoteNickname = await _userRepository.getNickname(userId);

    if (remoteNickname != null && remoteNickname.isNotEmpty) {
      await _userRepository.saveLocalNickname(remoteNickname);
      return true;
    }

    final localNickname = await _userRepository.getLocalNickname();

    if (localNickname != null && localNickname.isNotEmpty) {
      await _userRepository.saveNickname(userId, localNickname);
      return true;
    }

    return false;
  }
}

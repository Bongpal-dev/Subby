import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';

class SaveUserInfoUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  SaveUserInfoUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _groupRepository = groupRepository;

  Future<void> call({required String nickname}) async {
    final userId = _authRepository.currentUserId;

    await _userRepository.saveLocalNickname(nickname);

    if (userId == null) return;

    await _userRepository.saveNickname(userId, nickname);

    final groups = await _groupRepository.getAll();
    final groupCodes = groups.map((g) => g.code).toList();
    await _groupRepository.updateMemberNicknameInGroups(
      groupCodes,
      userId,
      nickname,
    );
  }
}

import 'package:subby/core/util/group_code_generator.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/nickname_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class CreateGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final NicknameRepository _nicknameRepository;
  final PendingChangeRepository _pendingChangeRepository;

  CreateGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required NicknameRepository nicknameRepository,
    required PendingChangeRepository pendingChangeRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _nicknameRepository = nicknameRepository,
        _pendingChangeRepository = pendingChangeRepository;

  Future<String> call(String name) async {
    final userId = _authRepository.currentUserId!;

    if (name.isEmpty) {
      throw Exception('그룹 이름을 입력해주세요');
    }
    if (name.length > 10) {
      throw Exception('그룹 이름은 10자 이내로 입력해주세요');
    }

    final exists = await _groupRepository.existsByName(name);
    if (exists) {
      throw Exception('이미 같은 이름의 그룹이 있습니다');
    }

    final newGroup = SubscriptionGroup(
      code: GroupCodeGenerator.generate(),
      name: name,
      ownerId: userId,
      members: [userId],
      createdAt: DateTime.now(),
    );

    await _groupRepository.create(newGroup);

    // 현재 닉네임 조회
    final nickname = await _nicknameRepository.getNickname(userId);
    _trySync(newGroup, nickname);

    return newGroup.code;
  }

  void _trySync(SubscriptionGroup group, String? ownerNickname) async {
    try {
      await _groupRepository.syncCreate(group, ownerNickname: ownerNickname);
    } catch (e) {
      await _pendingChangeRepository.saveGroupChange(
        group,
        ChangeAction.create,
      );
    }
  }
}

import 'package:subby/core/util/group_code_generator.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';

/// 새 그룹 생성 UseCase
class CreateGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;

  CreateGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository;

  /// 새 그룹 생성
  /// [name]: 그룹 이름 (최대 10자)
  /// 반환값: 생성된 그룹 코드
  Future<String> call(String name) async {
    // 1. 현재 사용자 ID
    final userId = _authRepository.currentUserId!;

    // 2. 그룹 이름 유효성 검사
    if (name.isEmpty) {
      throw Exception('그룹 이름을 입력해주세요');
    }
    if (name.length > 10) {
      throw Exception('그룹 이름은 10자 이내로 입력해주세요');
    }

    // 3. 중복 이름 체크
    final exists = await _groupRepository.existsByName(name);
    if (exists) {
      throw Exception('이미 같은 이름의 그룹이 있습니다');
    }

    // 4. 그룹 생성
    final newGroup = SubscriptionGroup(
      code: GroupCodeGenerator.generate(),
      name: name,
      ownerId: userId,
      members: [userId],
      createdAt: DateTime.now(),
    );

    await _groupRepository.create(newGroup);

    return newGroup.code;
  }
}

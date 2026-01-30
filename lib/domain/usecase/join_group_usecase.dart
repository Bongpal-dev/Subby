import 'package:cloud_functions/cloud_functions.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/nickname_repository.dart';

enum JoinGroupResult {
  success,
  alreadyJoined,
  notFound,
  error,
}

class JoinGroupUseCase {
  final GroupRepository _groupRepository;
  final AuthRepository _authRepository;
  final NicknameRepository _nicknameRepository;
  final FirebaseFunctions _functions;

  JoinGroupUseCase({
    required GroupRepository groupRepository,
    required AuthRepository authRepository,
    required NicknameRepository nicknameRepository,
    FirebaseFunctions? functions,
  })  : _groupRepository = groupRepository,
        _authRepository = authRepository,
        _nicknameRepository = nicknameRepository,
        _functions = functions ?? FirebaseFunctions.instance;

  Future<(JoinGroupResult, SubscriptionGroup?)> call(String groupCode) async {
    // 1. 로컬에서 이미 참여 중인지 확인
    final localGroup = await _groupRepository.getByCode(groupCode);

    if (localGroup != null) {
      return (JoinGroupResult.alreadyJoined, localGroup);
    }

    // 2. Cloud Function 호출
    try {
      // 현재 닉네임 조회
      final userId = _authRepository.currentUserId;
      final nickname = userId != null
          ? await _nicknameRepository.getNickname(userId)
          : null;

      final callable = _functions.httpsCallable('joinGroup');
      final result = await callable.call({
        'groupCode': groupCode,
        if (nickname != null) 'nickname': nickname,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      final success = data['success'] as bool;

      if (!success) {
        final error = data['error'] as String?;

        if (error == '존재하지 않는 그룹입니다') {
          return (JoinGroupResult.notFound, null);
        }

        return (JoinGroupResult.error, null);
      }

      // 3. 반환된 그룹 정보를 로컬에 저장
      final groupData = Map<String, dynamic>.from(data['group'] as Map);
      final group = SubscriptionGroup(
        code: groupData['code'] as String,
        name: groupData['name'] as String,
        ownerId: groupData['ownerId'] as String,
        members: List<String>.from(groupData['members'] as List),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          groupData['createdAt'] as int,
        ),
        updatedAt: groupData['updatedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(groupData['updatedAt'] as int)
            : null,
      );

      await _groupRepository.saveToLocal(group);

      return (JoinGroupResult.success, group);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'not-found') {
        return (JoinGroupResult.notFound, null);
      }

      return (JoinGroupResult.error, null);
    } catch (_) {
      return (JoinGroupResult.error, null);
    }
  }
}

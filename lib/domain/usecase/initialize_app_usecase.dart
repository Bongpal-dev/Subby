import 'package:subby/core/util/group_code_generator.dart';
import 'package:subby/domain/model/pending_change.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class InitializeAppUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final PendingChangeRepository _pendingChangeRepository;

  InitializeAppUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required PendingChangeRepository pendingChangeRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _pendingChangeRepository = pendingChangeRepository;

  Future<String> call() async {
    final userId = await _authRepository.signInAnonymously();

    final groups = await _groupRepository.getAll();

    if (groups.isNotEmpty) {
      return groups.first.code;
    }

    final defaultGroup = SubscriptionGroup(
      code: GroupCodeGenerator.generate(),
      name: '내 구독',
      ownerId: userId,
      members: [userId],
      createdAt: DateTime.now(),
    );

    await _groupRepository.create(defaultGroup);
    _trySync(defaultGroup);

    return defaultGroup.code;
  }

  void _trySync(SubscriptionGroup group) async {
    try {
      await _groupRepository.syncCreate(group);
    } catch (e) {
      await _pendingChangeRepository.saveGroupChange(
        group,
        ChangeAction.create,
      );
    }
  }
}

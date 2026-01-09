import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

class LeaveGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;

  LeaveGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required SubscriptionRepository subscriptionRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _subscriptionRepository = subscriptionRepository;

  Future<void> call(String groupCode) async {
    final userId = _authRepository.currentUserId!;

    await _subscriptionRepository.deleteByGroupCode(groupCode);
    await _groupRepository.leaveGroup(groupCode, userId);
  }
}

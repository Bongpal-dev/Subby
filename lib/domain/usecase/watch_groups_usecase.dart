import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/group_repository.dart';

/// 로컬 그룹 목록 감시 UseCase
class WatchGroupsUseCase {
  final GroupRepository _groupRepository;

  WatchGroupsUseCase({
    required GroupRepository groupRepository,
  }) : _groupRepository = groupRepository;

  Stream<List<SubscriptionGroup>> call() {
    return _groupRepository.watchAll();
  }
}

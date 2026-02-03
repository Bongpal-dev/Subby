import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/group_repository.dart';

class WatchGroupByCodeUseCase {
  final GroupRepository _groupRepository;

  WatchGroupByCodeUseCase({
    required GroupRepository groupRepository,
  }) : _groupRepository = groupRepository;

  Stream<SubscriptionGroup?> call(String code) {
    return _groupRepository.watchByCode(code);
  }
}

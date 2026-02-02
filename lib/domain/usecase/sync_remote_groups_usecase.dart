import 'dart:async';

import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';

/// 원격 그룹 실시간 동기화 UseCase
/// - 원격 그룹 변경 감시
/// - 로컬 DB에 동기화 (displayName은 로컬 값 유지)
class SyncRemoteGroupsUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;

  SyncRemoteGroupsUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository;

  /// 원격 그룹 감시 스트림 반환
  /// 콜백으로 동기화 처리
  StreamSubscription<List<SubscriptionGroup>>? call({
    required Future<void> Function(List<SubscriptionGroup> remoteGroups) onRemoteGroupsChanged,
  }) {
    final userId = _authRepository.currentUserId;
    if (userId == null) return null;

    return _groupRepository.watchRemoteGroupsByUserId(userId).listen(
      (remoteGroups) async {
        final localGroups = await _groupRepository.getAll();

        for (final remoteGroup in remoteGroups) {
          final localGroup = localGroups.where((g) => g.code == remoteGroup.code).firstOrNull;

          if (localGroup != null) {
            // displayName은 로컬 값 유지, 나머지는 원격 값으로 업데이트
            final updatedGroup = remoteGroup.copyWith(
              displayName: localGroup.displayName,
            );
            await _groupRepository.update(updatedGroup);
          }
        }

        await onRemoteGroupsChanged(remoteGroups);
      },
    );
  }
}

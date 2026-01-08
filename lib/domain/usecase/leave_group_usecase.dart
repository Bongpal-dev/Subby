import 'package:subby/data/datasource/group_remote_datasource.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';

class LeaveGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final GroupRemoteDataSource _remoteDataSource;

  LeaveGroupUseCase({
    required AuthRepository authRepository,
    required GroupRepository groupRepository,
    required GroupRemoteDataSource remoteDataSource,
  })  : _authRepository = authRepository,
        _groupRepository = groupRepository,
        _remoteDataSource = remoteDataSource;

  Future<void> call(String groupCode) async {
    final userId = _authRepository.currentUserId!;

    // 1. 로컬 삭제 (나가니까 필요 없음)
    await _groupRepository.delete(groupCode);

    // 2. Firestore 처리 (멤버 확인 후 삭제 또는 멤버에서 제거)
    _remoteDataSource.leaveGroup(groupCode, userId).catchError((_) {});
  }
}

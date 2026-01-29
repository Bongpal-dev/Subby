import 'package:subby/data/datasource/nickname_local_datasource.dart';
import 'package:subby/data/datasource/user_remote_datasource.dart';
import 'package:subby/domain/repository/nickname_repository.dart';

/// 닉네임 저장소 구현체
class NicknameRepositoryImpl implements NicknameRepository {
  final NicknameLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  NicknameRepositoryImpl({
    required NicknameLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<String?> getNickname(String userId) async {
    // 로컬 우선
    final localNickname = await _localDataSource.getNickname();
    if (localNickname != null) return localNickname;

    // 로컬에 없으면 원격에서 조회
    final remoteNickname = await _remoteDataSource.getNickname(userId);
    if (remoteNickname != null) {
      // 로컬에 캐시
      await _localDataSource.saveNickname(remoteNickname);
    }
    return remoteNickname;
  }

  @override
  Future<void> saveNickname(
    String userId,
    String nickname,
    List<String> groupCodes,
  ) async {
    // 로컬 저장
    await _localDataSource.saveNickname(nickname);

    // 원격 저장 + 그룹 동기화
    await _remoteDataSource.updateNicknameWithSync(userId, nickname, groupCodes);
  }

  @override
  Future<void> clearLocalNickname() async {
    await _localDataSource.clearNickname();
  }
}

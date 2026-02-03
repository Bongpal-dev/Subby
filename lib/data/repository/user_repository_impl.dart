import 'package:subby/data/datasource/user_local_datasource.dart';
import 'package:subby/data/datasource/user_remote_datasource.dart';
import 'package:subby/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({
    required UserLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<String?> getNickname(String userId) async {
    return await _remoteDataSource.getNickname(userId);
  }

  @override
  Future<String?> getLocalNickname() async {
    return await _localDataSource.getNickname();
  }

  @override
  Future<void> saveNickname(String userId, String nickname) async {
    await _remoteDataSource.saveNickname(userId, nickname);
  }

  @override
  Future<void> saveLocalNickname(String nickname) async {
    await _localDataSource.saveNickname(nickname);
  }

  @override
  Future<void> clearLocalNickname() async {
    await _localDataSource.clearNickname();
  }

  @override
  Future<String?> getLocalUserId() async {
    return await _localDataSource.getLocalUserId();
  }

  @override
  Future<void> saveLocalUserId(String id) async {
    await _localDataSource.saveLocalUserId(id);
  }

  @override
  Future<void> clearLocalUserId() async {
    await _localDataSource.clearLocalUserId();
  }
}

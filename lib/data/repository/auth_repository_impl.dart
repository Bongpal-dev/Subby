import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/domain/repository/auth_repository.dart';

/// 인증 저장소 구현체
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl({required FirebaseAuthDataSource dataSource})
      : _dataSource = dataSource;

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  Stream<String?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<String> signInAnonymously() async {
    if (_dataSource.currentUserId != null) {
      return _dataSource.currentUserId!;
    }
    return _dataSource.signInAnonymously();
  }

  @override
  Future<void> signOut() => _dataSource.signOut();
}

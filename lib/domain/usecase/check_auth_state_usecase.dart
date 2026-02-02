import 'package:subby/domain/repository/auth_repository.dart';

/// 인증 상태 정보
class AuthState {
  final String? userId;
  final bool isAnonymous;

  const AuthState({
    required this.userId,
    required this.isAnonymous,
  });

  bool get isLoggedIn => userId != null;
}

/// 현재 인증 상태 조회 UseCase
class CheckAuthStateUseCase {
  final AuthRepository _authRepository;

  CheckAuthStateUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  AuthState call() {
    return AuthState(
      userId: _authRepository.currentUserId,
      isAnonymous: _authRepository.isAnonymous,
    );
  }
}

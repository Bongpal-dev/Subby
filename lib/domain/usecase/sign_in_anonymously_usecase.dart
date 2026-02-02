import 'package:subby/domain/repository/auth_repository.dart';

/// 익명 로그인 UseCase
class SignInAnonymouslyUseCase {
  final AuthRepository _authRepository;

  SignInAnonymouslyUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<String> call() async {
    return await _authRepository.signInAnonymously();
  }
}

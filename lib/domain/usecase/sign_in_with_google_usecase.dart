import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/domain/repository/auth_repository.dart';

/// Google 로그인 UseCase
class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<GoogleSignInResult> call() async {
    return await _authRepository.signInWithGoogle();
  }
}

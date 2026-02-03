import 'package:subby/domain/repository/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _authRepository;

  WatchAuthStateUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Stream<String?> call() {
    return _authRepository.authStateChanges;
  }
}

import 'package:subby/domain/repository/auth_repository.dart';

class WatchIsAnonymousUseCase {
  final AuthRepository _authRepository;

  WatchIsAnonymousUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Stream<bool> call() {
    return _authRepository.authStateChanges.map((_) => _authRepository.isAnonymous);
  }
}

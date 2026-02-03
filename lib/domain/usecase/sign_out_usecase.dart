import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;
  final PendingChangeRepository _pendingChangeRepository;

  SignOutUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required GroupRepository groupRepository,
    required SubscriptionRepository subscriptionRepository,
    required PendingChangeRepository pendingChangeRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _groupRepository = groupRepository,
        _subscriptionRepository = subscriptionRepository,
        _pendingChangeRepository = pendingChangeRepository;

  Future<void> call() async {
    await _userRepository.clearLocalNickname();
    await _groupRepository.clearLocalData();
    await _subscriptionRepository.clearLocalData();
    await _pendingChangeRepository.deleteAll();

    // 2. 로그아웃
    await _authRepository.signOut();

    // 3. 익명 로그인으로 전환
    await _authRepository.signInAnonymously();
  }
}

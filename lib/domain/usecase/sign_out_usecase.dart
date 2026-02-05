import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/user_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/onboarding_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;
  final PendingChangeRepository _pendingChangeRepository;
  final OnboardingRepository _onboardingRepository;

  SignOutUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required GroupRepository groupRepository,
    required SubscriptionRepository subscriptionRepository,
    required PendingChangeRepository pendingChangeRepository,
    required OnboardingRepository onboardingRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _groupRepository = groupRepository,
        _subscriptionRepository = subscriptionRepository,
        _pendingChangeRepository = pendingChangeRepository,
        _onboardingRepository = onboardingRepository;

  Future<void> call() async {
    await _userRepository.clearLocalNickname();
    await _groupRepository.clearLocalData();
    await _subscriptionRepository.clearLocalData();
    await _pendingChangeRepository.deleteAll();
    await _onboardingRepository.resetSetup();
    await _onboardingRepository.setNicknameOnly(true);

    await _authRepository.signOut();
    // 익명 로그인은 setup 화면에서 처리
  }
}

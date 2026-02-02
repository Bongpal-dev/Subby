import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/nickname_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';

/// 로그아웃 UseCase
/// - 로컬 데이터 초기화
/// - 로그아웃
/// - 익명 로그인으로 전환
class SignOutUseCase {
  final AuthRepository _authRepository;
  final NicknameRepository _nicknameRepository;
  final GroupRepository _groupRepository;
  final SubscriptionRepository _subscriptionRepository;
  final PendingChangeRepository _pendingChangeRepository;

  SignOutUseCase({
    required AuthRepository authRepository,
    required NicknameRepository nicknameRepository,
    required GroupRepository groupRepository,
    required SubscriptionRepository subscriptionRepository,
    required PendingChangeRepository pendingChangeRepository,
  })  : _authRepository = authRepository,
        _nicknameRepository = nicknameRepository,
        _groupRepository = groupRepository,
        _subscriptionRepository = subscriptionRepository,
        _pendingChangeRepository = pendingChangeRepository;

  Future<void> call() async {
    // 1. 로컬 데이터 초기화
    await _nicknameRepository.clearLocalNickname();
    await _groupRepository.clearLocalData();
    await _subscriptionRepository.clearLocalData();
    await _pendingChangeRepository.deleteAll();

    // 2. 로그아웃
    await _authRepository.signOut();

    // 3. 익명 로그인으로 전환
    await _authRepository.signInAnonymously();
  }
}

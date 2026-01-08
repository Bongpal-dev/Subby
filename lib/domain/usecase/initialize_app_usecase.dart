import 'package:subby/core/util/group_code_generator.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/service/auth_service.dart';

/// 앱 초기화 UseCase
/// - 익명 로그인
/// - 기본 그룹 생성 (없는 경우)
class InitializeAppUseCase {
  final AuthService _authService;
  final GroupRepository _groupRepository;

  InitializeAppUseCase({
    required AuthService authService,
    required GroupRepository groupRepository,
  })  : _authService = authService,
        _groupRepository = groupRepository;

  /// 앱 초기화 실행
  /// 반환값: 현재 활성 그룹 코드
  Future<String> call() async {
    // 1. 익명 로그인
    final userId = await _authService.signInAnonymously();

    // 2. 기존 그룹 확인
    final groups = await _groupRepository.getAll();

    if (groups.isNotEmpty) {
      // 기존 그룹이 있으면 첫 번째 그룹 반환
      return groups.first.code;
    }

    // 3. 기본 그룹 생성
    final defaultGroup = SubscriptionGroup(
      code: GroupCodeGenerator.generate(),
      name: '내 구독',
      ownerId: userId,
      members: [userId],
      createdAt: DateTime.now(),
    );

    await _groupRepository.create(defaultGroup);

    return defaultGroup.code;
  }
}

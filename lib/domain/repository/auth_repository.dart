/// 인증 저장소 인터페이스
abstract class AuthRepository {
  /// 현재 사용자 ID (null이면 미인증)
  String? get currentUserId;

  /// 인증 상태 변화 스트림
  Stream<String?> get authStateChanges;

  /// 익명 로그인
  Future<String> signInAnonymously();

  /// 로그아웃
  Future<void> signOut();
}

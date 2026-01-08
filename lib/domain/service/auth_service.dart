/// 인증 서비스 인터페이스
/// Firebase Anonymous Auth 기반
abstract class AuthService {
  /// 현재 사용자 ID (null이면 미인증)
  String? get currentUserId;

  /// 인증 상태 변화 스트림
  Stream<String?> get authStateChanges;

  /// 익명 로그인
  /// 이미 로그인된 경우 기존 UID 반환
  Future<String> signInAnonymously();

  /// 로그아웃
  Future<void> signOut();
}

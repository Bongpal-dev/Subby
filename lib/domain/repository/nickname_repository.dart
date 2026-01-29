/// 닉네임 저장소 인터페이스
abstract class NicknameRepository {
  /// 현재 닉네임 조회 (로컬 우선, 없으면 원격)
  Future<String?> getNickname(String userId);

  /// 닉네임 저장 (로컬 + 원격 + 그룹 동기화)
  Future<void> saveNickname(String userId, String nickname, List<String> groupCodes);

  /// 닉네임 초기화 (로그아웃 시)
  Future<void> clearLocalNickname();
}

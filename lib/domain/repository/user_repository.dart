abstract class UserRepository {
  Future<String?> getNickname(String userId);
  Future<String?> getLocalNickname();
  Future<void> saveNickname(String userId, String nickname);
  Future<void> saveLocalNickname(String nickname);
  Future<void> clearLocalNickname();

  Future<String?> getLocalUserId();
  Future<void> saveLocalUserId(String id);
  Future<void> clearLocalUserId();
}

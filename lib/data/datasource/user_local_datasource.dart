import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const _nicknameKey = 'user_nickname';
  static const _localUserIdKey = 'local_user_id';

  Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nicknameKey, nickname);
  }

  Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey);
  }

  Future<void> clearNickname() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nicknameKey);
  }

  Future<void> saveLocalUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localUserIdKey, id);
  }

  Future<String?> getLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localUserIdKey);
  }

  Future<void> clearLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localUserIdKey);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// 닉네임 로컬 저장소 (SharedPreferences)
class NicknameLocalDataSource {
  static const _nicknameKey = 'user_nickname';

  /// 닉네임 저장
  Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nicknameKey, nickname);
  }

  /// 닉네임 조회
  Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey);
  }

  /// 닉네임 삭제
  Future<void> clearNickname() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nicknameKey);
  }
}

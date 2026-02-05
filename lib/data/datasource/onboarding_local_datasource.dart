import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _tutorialCompletedKey = 'coach_mark_completed';
  static const _setupCompletedKey = 'setup_completed';
  static const _nicknameOnlyKey = 'nickname_only';

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<bool> isTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tutorialCompletedKey) ?? false;
  }

  Future<void> setTutorialCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialCompletedKey, completed);
  }

  Future<bool> isSetupCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_setupCompletedKey) ?? false;
  }

  Future<void> setSetupCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_setupCompletedKey, completed);
  }

  Future<bool> isNicknameOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_nicknameOnlyKey) ?? false;
  }

  Future<void> setNicknameOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_nicknameOnlyKey, value);
  }
}

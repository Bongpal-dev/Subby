import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _themeModeKey = 'theme_mode';
  static const _defaultCurrencyKey = 'default_currency';
  static const _notificationEnabledKey = 'notification_enabled';
  static const _lastSelectedGroupCodeKey = 'last_selected_group_code';

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  Future<String?> getDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultCurrencyKey);
  }

  Future<void> setDefaultCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultCurrencyKey, currencyCode);
  }

  Future<bool?> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey);
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
  }

  Future<String?> getLastSelectedGroupCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSelectedGroupCodeKey);
  }

  Future<void> setLastSelectedGroupCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code != null) {
      await prefs.setString(_lastSelectedGroupCodeKey, code);
    } else {
      await prefs.remove(_lastSelectedGroupCodeKey);
    }
  }
}

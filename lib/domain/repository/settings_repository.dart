import 'package:flutter/material.dart';
import 'package:subby/domain/model/currency.dart';

abstract class SettingsRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);

  Future<Currency> getDefaultCurrency();
  Future<void> setDefaultCurrency(Currency currency);

  Future<bool> isNotificationEnabled();
  Future<void> setNotificationEnabled(bool enabled);

  Future<String?> getLastSelectedGroupCode();
  Future<void> setLastSelectedGroupCode(String? code);
}

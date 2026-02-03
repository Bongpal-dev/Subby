import 'package:flutter/material.dart';
import 'package:subby/data/datasource/settings_local_datasource.dart';
import 'package:subby/domain/model/currency.dart';
import 'package:subby/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<ThemeMode> getThemeMode() async {
    final value = await _localDataSource.getThemeMode();
    if (value == null) return ThemeMode.system;
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _localDataSource.setThemeMode(value);
  }

  @override
  Future<Currency> getDefaultCurrency() async {
    final code = await _localDataSource.getDefaultCurrency();
    if (code == null) return Currency.KRW;
    return Currency.fromCode(code) ?? Currency.KRW;
  }

  @override
  Future<void> setDefaultCurrency(Currency currency) {
    return _localDataSource.setDefaultCurrency(currency.code);
  }

  @override
  Future<bool> isNotificationEnabled() async {
    final value = await _localDataSource.isNotificationEnabled();
    return value ?? true;
  }

  @override
  Future<void> setNotificationEnabled(bool enabled) {
    return _localDataSource.setNotificationEnabled(enabled);
  }
}

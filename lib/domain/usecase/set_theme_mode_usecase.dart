import 'package:flutter/material.dart';
import 'package:subby/domain/repository/settings_repository.dart';

class SetThemeModeUseCase {
  final SettingsRepository _settingsRepository;

  SetThemeModeUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<void> call(ThemeMode mode) {
    return _settingsRepository.setThemeMode(mode);
  }
}

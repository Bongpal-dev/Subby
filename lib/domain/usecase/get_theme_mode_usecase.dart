import 'package:flutter/material.dart';
import 'package:subby/domain/repository/settings_repository.dart';

class GetThemeModeUseCase {
  final SettingsRepository _settingsRepository;

  GetThemeModeUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<ThemeMode> call() {
    return _settingsRepository.getThemeMode();
  }
}

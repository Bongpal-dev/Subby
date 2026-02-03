import 'package:subby/domain/repository/settings_repository.dart';

class SetNotificationEnabledUseCase {
  final SettingsRepository _settingsRepository;

  SetNotificationEnabledUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<void> call(bool enabled) {
    return _settingsRepository.setNotificationEnabled(enabled);
  }
}

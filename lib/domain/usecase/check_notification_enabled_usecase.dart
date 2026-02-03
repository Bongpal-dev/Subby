import 'package:subby/domain/repository/settings_repository.dart';

class CheckNotificationEnabledUseCase {
  final SettingsRepository _settingsRepository;

  CheckNotificationEnabledUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<bool> call() {
    return _settingsRepository.isNotificationEnabled();
  }
}

import 'package:subby/domain/repository/settings_repository.dart';

class SaveLastSelectedGroupCodeUseCase {
  final SettingsRepository _settingsRepository;

  SaveLastSelectedGroupCodeUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<void> call(String? code) {
    return _settingsRepository.setLastSelectedGroupCode(code);
  }
}

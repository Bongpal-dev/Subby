import 'package:subby/domain/repository/settings_repository.dart';

class GetLastSelectedGroupCodeUseCase {
  final SettingsRepository _settingsRepository;

  GetLastSelectedGroupCodeUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<String?> call() {
    return _settingsRepository.getLastSelectedGroupCode();
  }
}

import 'package:subby/domain/model/currency.dart';
import 'package:subby/domain/repository/settings_repository.dart';

class GetDefaultCurrencyUseCase {
  final SettingsRepository _settingsRepository;

  GetDefaultCurrencyUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<Currency> call() {
    return _settingsRepository.getDefaultCurrency();
  }
}

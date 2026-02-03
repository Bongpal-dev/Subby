import 'package:subby/domain/model/currency.dart';
import 'package:subby/domain/repository/settings_repository.dart';

class SetDefaultCurrencyUseCase {
  final SettingsRepository _settingsRepository;

  SetDefaultCurrencyUseCase({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  Future<void> call(Currency currency) {
    return _settingsRepository.setDefaultCurrency(currency);
  }
}

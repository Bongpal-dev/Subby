import 'package:subby/domain/model/exchange_rate.dart';
import 'package:subby/domain/repository/exchange_rate_repository.dart';

class GetExchangeRateUseCase {
  final ExchangeRateRepository _exchangeRateRepository;

  GetExchangeRateUseCase({
    required ExchangeRateRepository exchangeRateRepository,
  }) : _exchangeRateRepository = exchangeRateRepository;

  Future<ExchangeRate?> call() {
    return _exchangeRateRepository.getExchangeRate();
  }
}

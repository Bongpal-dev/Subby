import '../model/exchange_rate.dart';

abstract class ExchangeRateRepository {
  Future<ExchangeRate?> getExchangeRate();
}

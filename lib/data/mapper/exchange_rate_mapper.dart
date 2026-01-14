import '../../domain/model/exchange_rate.dart';
import '../dto/exchange_rate_dto.dart';

extension ExchangeRateDtoToModel on ExchangeRateDto {
  ExchangeRate toModel() {
    return ExchangeRate(
      usd: usd,
      krw: krw,
      eur: eur,
      jpy: jpy,
      updatedAt: updatedAt,
    );
  }
}

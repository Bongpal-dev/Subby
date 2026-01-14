class ExchangeRate {
  final double usd;
  final double krw;
  final double eur;
  final double jpy;
  final DateTime updatedAt;

  const ExchangeRate({
    required this.usd,
    required this.krw,
    required this.eur,
    required this.jpy,
    required this.updatedAt,
  });

  double getRate(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return usd;
      case 'KRW':
        return _roundRate(krw);
      case 'EUR':
        return _roundRate(eur);
      case 'JPY':
        return _roundRate(jpy);
      default:
        return 1.0;
    }
  }

  // 환율 반올림: 1 미만은 소수점 2자리, 그 외는 10 단위로 반올림
  double _roundRate(double rate) {
    if (rate < 1) {
      return (rate * 100).round() / 100;
    }
    return (rate / 10).round() * 10;
  }

  double convert(double amount, String from, String to) {
    final fromRate = getRate(from);
    final toRate = getRate(to);

    return amount / fromRate * toRate;
  }
}

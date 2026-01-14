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
        return krw;
      case 'EUR':
        return eur;
      case 'JPY':
        return jpy;
      default:
        return 1.0;
    }
  }

  double convert(double amount, String from, String to) {
    final fromRate = getRate(from);
    final toRate = getRate(to);

    return amount / fromRate * toRate;
  }
}

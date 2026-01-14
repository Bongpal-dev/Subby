enum Currency {
  KRW(symbol: '₩', code: 'KRW', name: '원', decimalDigits: 0),
  USD(symbol: '\$', code: 'USD', name: '달러', decimalDigits: 2),
  EUR(symbol: '€', code: 'EUR', name: '유로', decimalDigits: 2),
  JPY(symbol: '¥', code: 'JPY', name: '엔', decimalDigits: 0);

  final String symbol;
  final String code;
  final String name;
  final int decimalDigits;

  const Currency({
    required this.symbol,
    required this.code,
    required this.name,
    required this.decimalDigits,
  });

  static Currency? fromCode(String code) {
    try {
      return Currency.values.firstWhere(
        (c) => c.code == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

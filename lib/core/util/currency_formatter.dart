class CurrencyFormatter {
  CurrencyFormatter._();

  static final _thousandSeparator = RegExp(r'(\d)(?=(\d{3})+(?!\d))');

  static String formatKrw(int value) {
    return value.toString().replaceAllMapped(
      _thousandSeparator,
      (m) => '${m[1]},',
    );
  }

  static String formatUsd(double value) {
    return value.toStringAsFixed(2);
  }
}

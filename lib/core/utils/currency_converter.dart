import 'package:intl/intl.dart';

import '../../domain/model/currency.dart';
import '../../domain/model/exchange_rate.dart';

class CurrencyConverter {
  final ExchangeRate _exchangeRate;

  CurrencyConverter(this._exchangeRate);

  double convert(double amount, Currency from, Currency to) {
    return _exchangeRate.convert(amount, from.code, to.code);
  }

  double toKRW(double amount, Currency from) {
    return convert(amount, from, Currency.KRW);
  }

  String format(double amount, Currency currency) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    );

    return formatter.format(amount);
  }

  String formatWithConversion(
    double amount,
    Currency from, {
    Currency to = Currency.KRW,
  }) {
    if (from == to) {
      return format(amount, from);
    }

    final converted = convert(amount, from, to);
    final original = format(amount, from);
    final convertedFormatted = format(converted, to);

    return '$original (≈ $convertedFormatted)';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:subby/core/utils/currency_converter.dart';
import 'package:subby/domain/model/currency.dart';
import 'package:subby/domain/model/exchange_rate.dart';

void main() {
  late CurrencyConverter converter;

  setUp(() {
    converter = CurrencyConverter(
      ExchangeRate(
        usd: 1.0,
        krw: 1345.5,
        eur: 0.92,
        jpy: 149.8,
        updatedAt: DateTime(2025, 3, 1),
      ),
    );
  });

  group('convert', () {
    test('USD → KRW', () {
      final result = converter.convert(10.0, Currency.USD, Currency.KRW);
      expect(result, 13500.0); // getRate 반올림 적용: 1350
    });

    test('동일 통화', () {
      final result = converter.convert(9900.0, Currency.KRW, Currency.KRW);
      expect(result, 9900.0);
    });
  });

  group('format', () {
    test('KRW: ₩ + 천 단위 구분자, 소수점 없음', () {
      final result = converter.format(9900.0, Currency.KRW);
      expect(result, contains('₩'));
      expect(result, contains('9,900'));
    });

    test('USD: \$ + 소수점 2자리', () {
      final result = converter.format(9.99, Currency.USD);
      expect(result, contains('\$'));
      expect(result, contains('9.99'));
    });
  });

  group('formatWithConversion', () {
    test('동일 통화 → 변환 없이 포맷만', () {
      final result = converter.formatWithConversion(
        9900.0,
        Currency.KRW,
        to: Currency.KRW,
      );
      expect(result.contains('≈'), isFalse);
    });

    test('다른 통화 → "원래 (≈ 변환)" 형식', () {
      final result = converter.formatWithConversion(
        9.99,
        Currency.USD,
        to: Currency.KRW,
      );
      expect(result, contains('≈'));
      expect(result, contains('\$'));
      expect(result, contains('₩'));
    });
  });
}

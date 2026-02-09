import 'package:flutter_test/flutter_test.dart';
import 'package:subby/domain/model/currency.dart';

void main() {
  group('Currency enum', () {
    test('KRW: symbol ₩, decimalDigits 0', () {
      expect(Currency.KRW.symbol, '₩');
      expect(Currency.KRW.decimalDigits, 0);
    });

    test('USD: symbol \$, decimalDigits 2', () {
      expect(Currency.USD.symbol, '\$');
      expect(Currency.USD.decimalDigits, 2);
    });

    test('EUR: symbol €, decimalDigits 2', () {
      expect(Currency.EUR.symbol, '€');
      expect(Currency.EUR.decimalDigits, 2);
    });

    test('JPY: symbol ¥, decimalDigits 0', () {
      expect(Currency.JPY.symbol, '¥');
      expect(Currency.JPY.decimalDigits, 0);
    });
  });

  group('fromCode', () {
    test('유효한 코드 → Currency 반환', () {
      expect(Currency.fromCode('KRW'), Currency.KRW);
      expect(Currency.fromCode('USD'), Currency.USD);
    });

    test('대소문자 무관', () {
      expect(Currency.fromCode('krw'), Currency.KRW);
      expect(Currency.fromCode('usd'), Currency.USD);
    });

    test('잘못된 코드 → null', () {
      expect(Currency.fromCode('GBP'), isNull);
      expect(Currency.fromCode(''), isNull);
    });
  });
}

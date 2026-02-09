import 'package:flutter_test/flutter_test.dart';
import 'package:subby/core/util/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.formatKrw', () {
    test('천 단위 구분자', () {
      expect(CurrencyFormatter.formatKrw(1000000), '1,000,000');
    });

    test('1000 미만은 구분자 없음', () {
      expect(CurrencyFormatter.formatKrw(999), '999');
    });

    test('0', () {
      expect(CurrencyFormatter.formatKrw(0), '0');
    });
  });

  group('CurrencyFormatter.formatUsd', () {
    test('소수점 2자리 고정', () {
      expect(CurrencyFormatter.formatUsd(9.99), '9.99');
    });

    test('정수도 소수점 2자리', () {
      expect(CurrencyFormatter.formatUsd(10.0), '10.00');
    });

    test('0', () {
      expect(CurrencyFormatter.formatUsd(0), '0.00');
    });
  });
}

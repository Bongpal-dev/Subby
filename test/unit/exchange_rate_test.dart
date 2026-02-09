import 'package:flutter_test/flutter_test.dart';
import 'package:subby/domain/model/exchange_rate.dart';

void main() {
  late ExchangeRate rate;

  setUp(() {
    rate = ExchangeRate(
      usd: 1.0,
      krw: 1345.5,
      eur: 0.92,
      jpy: 149.8,
      updatedAt: DateTime(2025, 3, 1),
    );
  });

  group('getRate', () {
    test('USD는 반올림 없이 1.0 반환', () {
      expect(rate.getRate('USD'), 1.0);
    });

    test('KRW: rate >= 1 → 10단위 반올림 (1345.5 → 1350)', () {
      expect(rate.getRate('KRW'), 1350);
    });

    test('EUR: rate < 1 → 소수점 2자리 (0.92 → 0.92)', () {
      expect(rate.getRate('EUR'), 0.92);
    });

    test('JPY: rate >= 1 → 10단위 반올림 (149.8 → 150)', () {
      expect(rate.getRate('JPY'), 150);
    });

    test('미지원 통화 코드 → 1.0', () {
      expect(rate.getRate('GBP'), 1.0);
    });

    test('대소문자 무관', () {
      expect(rate.getRate('usd'), 1.0);
      expect(rate.getRate('krw'), 1350);
    });
  });

  group('convert', () {
    test('USD → KRW', () {
      final result = rate.convert(10.0, 'USD', 'KRW');
      // 10 / 1.0 * 1350 = 13500
      expect(result, 13500.0);
    });

    test('KRW → USD', () {
      final result = rate.convert(13500.0, 'KRW', 'USD');
      // 13500 / 1350 * 1.0 = 10.0
      expect(result, 10.0);
    });

    test('동일 통화 변환 → 금액 유지', () {
      final result = rate.convert(9900.0, 'KRW', 'KRW');
      expect(result, 9900.0);
    });

    test('EUR → JPY (cross-rate)', () {
      final result = rate.convert(100.0, 'EUR', 'JPY');
      // 100 / 0.92 * 150 ≈ 16304.35
      expect(result, closeTo(16304.35, 0.1));
    });
  });
}

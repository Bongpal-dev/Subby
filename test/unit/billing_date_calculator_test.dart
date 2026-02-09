import 'package:flutter_test/flutter_test.dart';
import 'package:subby/core/util/billing_date_calculator.dart';

void main() {
  group('nextMonthlyBillingDate', () {
    test('31일 결제 → 2월 평년: 28일', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 31,
        from: DateTime(2025, 2, 1),
      );
      expect(result, DateTime(2025, 2, 28));
    });

    test('31일 결제 → 2월 윤년: 29일', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 31,
        from: DateTime(2024, 2, 1),
      );
      expect(result, DateTime(2024, 2, 29));
    });

    test('29일 결제 → 2월 평년: 28일', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 29,
        from: DateTime(2025, 1, 30),
      );
      expect(result, DateTime(2025, 2, 28));
    });

    test('29일 결제 → 2월 윤년: 29일', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 29,
        from: DateTime(2024, 1, 30),
      );
      expect(result, DateTime(2024, 2, 29));
    });

    test('31일 결제 → 4월(30일): 30일', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 31,
        from: DateTime(2025, 4, 1),
      );
      expect(result, DateTime(2025, 4, 30));
    });

    test('12월 → 1월 연도 전환', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 15,
        from: DateTime(2025, 12, 16),
      );
      expect(result, DateTime(2026, 1, 15));
    });

    test('오늘 == 결제일: 이번 달 반환', () {
      // from.day(15) > billingDay(15) 가 false이므로 이번 달
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 15,
        from: DateTime(2025, 3, 15),
      );
      expect(result, DateTime(2025, 3, 15));
    });

    test('오늘 > 결제일: 다음 달 반환', () {
      final result = BillingDateCalculator.nextMonthlyBillingDate(
        billingDay: 10,
        from: DateTime(2025, 3, 15),
      );
      expect(result, DateTime(2025, 4, 10));
    });
  });

  group('nextYearlyBillingDate', () {
    test('2월 29일 → 평년: 28일', () {
      final result = BillingDateCalculator.nextYearlyBillingDate(
        billingDay: 29,
        billingMonth: 2,
        from: DateTime(2024, 3, 1),
      );
      expect(result, DateTime(2025, 2, 28));
    });

    test('2월 29일 → 윤년: 29일', () {
      final result = BillingDateCalculator.nextYearlyBillingDate(
        billingDay: 29,
        billingMonth: 2,
        from: DateTime(2023, 3, 1),
      );
      expect(result, DateTime(2024, 2, 29));
    });

    test('올해 결제일 안 지남: 올해 반환', () {
      final result = BillingDateCalculator.nextYearlyBillingDate(
        billingDay: 15,
        billingMonth: 6,
        from: DateTime(2025, 1, 1),
      );
      expect(result, DateTime(2025, 6, 15));
    });

    test('올해 결제일 지남: 내년 반환', () {
      final result = BillingDateCalculator.nextYearlyBillingDate(
        billingDay: 15,
        billingMonth: 3,
        from: DateTime(2025, 3, 16),
      );
      expect(result, DateTime(2026, 3, 15));
    });
  });

  group('format', () {
    test('한 자리 월/일 앞에 0 패딩', () {
      expect(
        BillingDateCalculator.format(DateTime(2025, 3, 5)),
        '2025.03.05',
      );
    });

    test('두 자리 월/일 그대로', () {
      expect(
        BillingDateCalculator.format(DateTime(2025, 12, 25)),
        '2025.12.25',
      );
    });
  });
}

class BillingDateCalculator {
  BillingDateCalculator._();

  /// 다음 월간 결제일 계산
  /// [billingDay]: 결제일 (1-31)
  /// [from]: 기준 날짜
  static DateTime nextMonthlyBillingDate({
    required int billingDay,
    required DateTime from,
  }) {
    int year = from.year;
    int month = from.month;
    if (from.day > billingDay) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final actualDay =
        billingDay > lastDayOfMonth ? lastDayOfMonth : billingDay;
    return DateTime(year, month, actualDay);
  }

  /// 다음 연간 결제일 계산
  /// [billingDay]: 결제일 (1-31)
  /// [billingMonth]: 결제월 (1-12)
  /// [from]: 기준 날짜
  static DateTime nextYearlyBillingDate({
    required int billingDay,
    required int billingMonth,
    required DateTime from,
  }) {
    int year = from.year;
    final lastDayOfBillingMonth = DateTime(year, billingMonth + 1, 0).day;
    final actualBillingDay =
        billingDay > lastDayOfBillingMonth ? lastDayOfBillingMonth : billingDay;
    final thisYearActualDate =
        DateTime(year, billingMonth, actualBillingDay);

    if (from.isAfter(thisYearActualDate)) {
      year++;
    }
    final nextLastDayOfMonth = DateTime(year, billingMonth + 1, 0).day;
    final nextBillingDay =
        billingDay > nextLastDayOfMonth ? nextLastDayOfMonth : billingDay;
    return DateTime(year, billingMonth, nextBillingDay);
  }

  /// DateTime을 'YYYY.MM.DD' 형식으로 포맷
  static String format(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

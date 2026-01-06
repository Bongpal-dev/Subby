class Subscription {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final int billingDay;
  final String period;
  final String? category;
  final String? memo;
  final double? feeRatePercent;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingDay,
    required this.period,
    this.category,
    this.memo,
    this.feeRatePercent,
    required this.createdAt,
  });

  Subscription copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    int? billingDay,
    String? period,
    String? category,
    String? memo,
    double? feeRatePercent,
    DateTime? createdAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingDay: billingDay ?? this.billingDay,
      period: period ?? this.period,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      feeRatePercent: feeRatePercent ?? this.feeRatePercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

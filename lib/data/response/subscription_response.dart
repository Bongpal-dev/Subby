class SubscriptionResponse {
  final String id;
  final String groupCode;
  final String name;
  final double amount;
  final String currency;
  final int billingDay;
  final String period;
  final String? category;
  final String? memo;
  final double? feeRatePercent;
  final int createdAt;

  SubscriptionResponse({
    required this.id,
    required this.groupCode,
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

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      id: json['id'] as String,
      groupCode: json['groupCode'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      billingDay: json['billingDay'] as int,
      period: json['period'] as String,
      category: json['category'] as String?,
      memo: json['memo'] as String?,
      feeRatePercent: (json['feeRatePercent'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupCode': groupCode,
      'name': name,
      'amount': amount,
      'currency': currency,
      'billingDay': billingDay,
      'period': period,
      'category': category,
      'memo': memo,
      'feeRatePercent': feeRatePercent,
      'createdAt': createdAt,
    };
  }
}

import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';

class SubscriptionDto {
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
  final DateTime createdAt;
  final DateTime? updatedAt;

  SubscriptionDto({
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
    this.updatedAt,
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
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
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
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
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}

extension UserSubscriptionRowToDto on UserSubscription {
  SubscriptionDto toDto() {
    return SubscriptionDto(
      id: id,
      groupCode: groupCode,
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      period: period,
      category: category,
      memo: memo,
      feeRatePercent: feeRatePercent,
      createdAt: createdAt,
    );
  }
}

extension SubscriptionDtoToCompanion on SubscriptionDto {
  UserSubscriptionsCompanion toCompanion() {
    return UserSubscriptionsCompanion.insert(
      id: id,
      groupCode: groupCode,
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      period: period,
      category: Value.absentIfNull(category),
      memo: Value.absentIfNull(memo),
      feeRatePercent: Value.absentIfNull(feeRatePercent),
      createdAt: createdAt,
    );
  }
}

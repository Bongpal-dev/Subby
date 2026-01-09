import 'package:subby/domain/model/sync_status.dart';

class UserSubscription {
  final String id;
  final String groupCode; // 필수 - 모든 구독은 그룹에 속함
  final String name;
  final double amount;
  final String currency;
  final int billingDay;
  final String period;
  final String? category;
  final String? memo;
  final double? feeRatePercent;
  final DateTime createdAt;

  // 동기화 관련 필드
  final String? createdBy;
  final String? lastModifiedBy;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;

  UserSubscription({
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
    this.createdBy,
    this.lastModifiedBy,
    this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });

  UserSubscription copyWith({
    String? id,
    String? groupCode,
    String? name,
    double? amount,
    String? currency,
    int? billingDay,
    String? period,
    String? category,
    bool clearCategory = false,
    String? memo,
    bool clearMemo = false,
    double? feeRatePercent,
    DateTime? createdAt,
    String? createdBy,
    String? lastModifiedBy,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      groupCode: groupCode ?? this.groupCode,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingDay: billingDay ?? this.billingDay,
      period: period ?? this.period,
      category: clearCategory ? null : (category ?? this.category),
      memo: clearMemo ? null : (memo ?? this.memo),
      feeRatePercent: feeRatePercent ?? this.feeRatePercent,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}

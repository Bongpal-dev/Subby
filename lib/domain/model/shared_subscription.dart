import 'package:subby/domain/model/sync_status.dart';

/// 공유방 구독 모델
class SharedSubscription {
  /// UUID
  final String id;

  /// 소속 공유방 코드
  final String roomCode;

  /// 구독 서비스명
  final String name;

  /// 금액
  final double amount;

  /// 통화 (KRW, USD)
  final String currency;

  /// 결제일
  final int billingDay;

  /// 결제 주기 (MONTHLY, YEARLY)
  final String period;

  /// 카테고리
  final String? category;

  /// 메모
  final String? memo;

  /// 생성자 UID
  final String createdBy;

  /// 마지막 수정자 UID
  final String? lastModifiedBy;

  /// 생성일시
  final DateTime createdAt;

  /// 수정일시
  final DateTime? updatedAt;

  /// 동기화 상태
  final SyncStatus syncStatus;

  const SharedSubscription({
    required this.id,
    required this.roomCode,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingDay,
    required this.period,
    this.category,
    this.memo,
    required this.createdBy,
    this.lastModifiedBy,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });

  SharedSubscription copyWith({
    String? id,
    String? roomCode,
    String? name,
    double? amount,
    String? currency,
    int? billingDay,
    String? period,
    String? category,
    bool clearCategory = false,
    String? memo,
    bool clearMemo = false,
    String? createdBy,
    String? lastModifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return SharedSubscription(
      id: id ?? this.id,
      roomCode: roomCode ?? this.roomCode,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingDay: billingDay ?? this.billingDay,
      period: period ?? this.period,
      category: clearCategory ? null : (category ?? this.category),
      memo: clearMemo ? null : (memo ?? this.memo),
      createdBy: createdBy ?? this.createdBy,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Firebase Realtime DB JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomCode': roomCode,
      'name': name,
      'amount': amount,
      'currency': currency,
      'billingDay': billingDay,
      'period': period,
      'category': category,
      'memo': memo,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Firebase Realtime DB JSON에서 생성
  factory SharedSubscription.fromJson(Map<String, dynamic> json) {
    return SharedSubscription(
      id: json['id'] as String,
      roomCode: json['roomCode'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      billingDay: json['billingDay'] as int,
      period: json['period'] as String,
      category: json['category'] as String?,
      memo: json['memo'] as String?,
      createdBy: json['createdBy'] as String,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
      syncStatus: SyncStatus.synced,
    );
  }
}

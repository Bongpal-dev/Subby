import 'package:subby/domain/model/field_conflict.dart';
import 'package:subby/domain/model/user_subscription.dart';

/// 구독 충돌 정보
class SubscriptionConflict {
  final String subscriptionId;
  final List<FieldConflict> conflicts;
  final UserSubscription localSubscription;
  final UserSubscription serverSubscription;

  const SubscriptionConflict({
    required this.subscriptionId,
    required this.conflicts,
    required this.localSubscription,
    required this.serverSubscription,
  });

  /// 충돌 필드 개수
  int get conflictCount => conflicts.length;
}

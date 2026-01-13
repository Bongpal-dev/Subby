import 'package:subby/domain/model/field_conflict.dart';
import 'package:subby/domain/model/subscription_conflict.dart';
import 'package:subby/domain/model/user_subscription.dart';

/// 구독 충돌 감지 UseCase
class DetectSubscriptionConflictUseCase {
  /// 로컬 구독과 서버 구독 목록을 비교하여 충돌 감지
  /// 충돌이 없으면 null 반환
  SubscriptionConflict? call(
    UserSubscription local,
    List<UserSubscription> serverList,
  ) {
    final server = _findServerMatch(local, serverList);

    if (server == null) {
      return null;
    }

    final conflicts = _compareFields(local, server);

    if (conflicts.isEmpty) {
      return null;
    }

    return SubscriptionConflict(
      subscriptionId: local.id,
      conflicts: conflicts,
      localSubscription: local,
      serverSubscription: server,
    );
  }

  UserSubscription? _findServerMatch(
    UserSubscription local,
    List<UserSubscription> serverList,
  ) {
    try {
      return serverList.firstWhere((s) => s.id == local.id);
    } catch (_) {
      return null;
    }
  }

  List<FieldConflict> _compareFields(
    UserSubscription local,
    UserSubscription server,
  ) {
    final conflicts = <FieldConflict>[];

    _addIfDifferent(
      conflicts,
      '금액',
      local.amount.toString(),
      server.amount.toString(),
    );
    _addIfDifferent(
      conflicts,
      '결제일',
      local.billingDay.toString(),
      server.billingDay.toString(),
    );
    _addIfDifferent(conflicts, '결제 주기', local.period, server.period);

    return conflicts;
  }

  void _addIfDifferent(
    List<FieldConflict> conflicts,
    String fieldName,
    String localValue,
    String serverValue,
  ) {
    if (localValue != serverValue) {
      conflicts.add(
        FieldConflict(
          fieldName: fieldName,
          localValue: localValue,
          serverValue: serverValue,
        ),
      );
    }
  }
}

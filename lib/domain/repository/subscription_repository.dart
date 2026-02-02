import 'package:subby/domain/model/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<List<UserSubscription>> getAll();
  Future<UserSubscription?> getById(String id);
  Future<void> create(UserSubscription subscription);
  Future<void> update(UserSubscription subscription);
  Future<void> delete(String id);
  Future<void> deleteByGroupCode(String groupCode);
  Stream<List<UserSubscription>> watchAll();

  Future<void> syncCreate(UserSubscription subscription);
  Future<void> syncUpdate(UserSubscription subscription);
  Future<void> syncDelete(String groupCode, String subscriptionId);

  /// 서버에서 그룹의 모든 구독 조회 (충돌 감지용)
  Future<List<UserSubscription>> fetchRemoteByGroupCode(String groupCode);

  /// 로컬 데이터 전체 삭제 (로그아웃 시)
  Future<void> clearLocalData();
}

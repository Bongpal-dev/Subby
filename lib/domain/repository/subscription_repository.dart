import 'package:subby/domain/model/user_subscription.dart';

abstract class SubscriptionRepository {
  Future<List<UserSubscription>> getAll();
  Future<UserSubscription?> getById(String id);
  Future<void> create(UserSubscription subscription);
  Future<void> update(UserSubscription subscription);
  Future<void> delete(String id);
  Future<void> deleteByGroupCode(String groupCode);
  Stream<List<UserSubscription>> watchAll();

  Future<void> syncCreate(UserSubscription subscription, {String? updatedBy});
  Future<void> syncUpdate(UserSubscription subscription, {String? updatedBy});
  Future<void> syncDelete(String groupCode, String subscriptionId, {String? updatedBy});

  /// 서버에서 그룹의 모든 구독 조회 (충돌 감지용)
  Future<List<UserSubscription>> fetchRemoteByGroupCode(String groupCode);

  /// 로컬 데이터 전체 삭제 (로그아웃 시)
  Future<void> clearLocalData();

  /// 실시간 동기화 시작
  void startRemoteSync(String groupCode);

  /// 실시간 동기화 중지
  void stopRemoteSync();
}

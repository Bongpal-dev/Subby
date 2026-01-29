import 'package:subby/domain/model/subscription_group.dart';

abstract class GroupRepository {
  Future<List<SubscriptionGroup>> getAll();
  Future<SubscriptionGroup?> getByCode(String code);
  Future<bool> existsByName(String name);

  Future<void> create(SubscriptionGroup group);
  Future<void> update(SubscriptionGroup group);
  Future<void> leaveGroup(String code, String userId);
  Future<void> updateDisplayName(String code, String? displayName);

  Stream<List<SubscriptionGroup>> watchAll();
  Stream<SubscriptionGroup?> watchByCode(String code);

  Future<void> syncCreate(SubscriptionGroup group);
  Future<void> syncUpdate(SubscriptionGroup group);
  Future<void> syncLeave(String code, String userId);

  /// 원격에서 그룹 정보 조회 (참여 전 확인용)
  Future<SubscriptionGroup?> fetchRemoteByCode(String code);

  /// 그룹 참여 (원격 멤버 추가 + 로컬 저장)
  Future<void> joinGroup(String code, String userId);

  /// 로컬에만 저장 (Cloud Function 응답 저장용)
  Future<void> saveToLocal(SubscriptionGroup group);

  /// 사용자가 속한 모든 그룹 조회 (원격)
  Future<List<SubscriptionGroup>> fetchRemoteGroupsByUserId(String userId);

  /// 사용자가 속한 모든 그룹 실시간 감시 (원격)
  Stream<List<SubscriptionGroup>> watchRemoteGroupsByUserId(String userId);
}

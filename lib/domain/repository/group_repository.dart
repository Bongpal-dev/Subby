import 'package:subby/domain/model/subscription_group.dart';

/// 그룹 저장소 인터페이스
/// 로컬 DB 기준, Firebase는 동기화용
abstract class GroupRepository {
  /// 모든 그룹 조회 (사용자가 속한 그룹)
  Future<List<SubscriptionGroup>> getAll();

  /// 코드로 그룹 조회
  Future<SubscriptionGroup?> getByCode(String code);

  /// 그룹 생성
  Future<void> create(SubscriptionGroup group);

  /// 그룹 수정 (이름 변경 등)
  Future<void> update(SubscriptionGroup group);

  /// 그룹 삭제
  Future<void> delete(String code);

  /// 그룹 목록 실시간 감시
  Stream<List<SubscriptionGroup>> watchAll();

  /// 특정 그룹 실시간 감시
  Stream<SubscriptionGroup?> watchByCode(String code);

  /// 그룹 이름 존재 여부 확인
  Future<bool> existsByName(String name);
}

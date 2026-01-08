import 'package:firebase_database/firebase_database.dart';
import 'package:subby/domain/model/subscription_group.dart';

class GroupRemoteDataSource {
  final DatabaseReference _dbRef;

  GroupRemoteDataSource()
      : _dbRef = FirebaseDatabase.instanceFor(
          app: FirebaseDatabase.instance.app,
          databaseURL:
              'https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref();

  /// 그룹 저장
  Future<void> saveGroup(SubscriptionGroup group) async {
    await _dbRef.child('groups/${group.code}').set({
      'code': group.code,
      'name': group.name,
      'ownerId': group.ownerId,
      'members': group.members,
      'createdAt': group.createdAt.millisecondsSinceEpoch,
      'updatedAt': group.updatedAt?.millisecondsSinceEpoch,
    });
  }

  /// 그룹 조회
  Future<SubscriptionGroup?> getGroup(String code) async {
    final snapshot = await _dbRef.child('groups/$code').get();
    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }
    return _toGroup(snapshot.value as Map);
  }

  /// 그룹 삭제
  Future<void> deleteGroup(String code) async {
    await _dbRef.child('groups/$code').remove();
  }

  SubscriptionGroup _toGroup(Map data) {
    return SubscriptionGroup(
      code: data['code'] as String,
      name: data['name'] as String,
      ownerId: data['ownerId'] as String,
      members: List<String>.from(data['members'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int)
          : null,
    );
  }
}

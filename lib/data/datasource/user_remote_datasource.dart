import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore users 컬렉션 관리
/// - 닉네임 저장/조회
/// - 그룹 내 멤버 닉네임 동기화
class UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  /// 닉네임 저장 (users 컬렉션)
  Future<void> saveNickname(String userId, String nickname) async {
    await _usersRef.doc(userId).set({
      'nickname': nickname,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 닉네임 조회
  Future<String?> getNickname(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return doc.data()!['nickname'] as String?;
  }

  /// 닉네임 변경 + 속한 그룹들에 동기화
  Future<void> updateNicknameWithSync(
    String userId,
    String nickname,
    List<String> groupCodes,
  ) async {
    final batch = _firestore.batch();

    // 1. users 컬렉션 업데이트
    batch.set(
      _usersRef.doc(userId),
      {
        'nickname': nickname,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // 2. 각 그룹의 members.{userId}.nickname 업데이트
    for (final groupCode in groupCodes) {
      batch.update(
        _groupsRef.doc(groupCode),
        {'members.$userId.nickname': nickname},
      );
    }

    await batch.commit();
  }
}

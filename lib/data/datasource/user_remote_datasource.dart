import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  Future<void> saveNickname(String userId, String nickname) async {
    await _usersRef.doc(userId).set({
      'nickname': nickname,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> getNickname(String userId) async {
    final doc = await _usersRef.doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return doc.data()!['nickname'] as String?;
  }
}

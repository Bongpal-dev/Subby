import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subby/domain/model/subscription_group.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  Future<void> saveGroup(SubscriptionGroup group) async {
    await _groupsRef.doc(group.code).set({
      'code': group.code,
      'name': group.name,
      'ownerId': group.ownerId,
      'members': group.members,
      'createdAt': Timestamp.fromDate(group.createdAt),
      'updatedAt': group.updatedAt != null
          ? Timestamp.fromDate(group.updatedAt!)
          : null,
    });
  }

  Future<SubscriptionGroup?> getGroup(String code) async {
    final doc = await _groupsRef.doc(code).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return _toGroup(doc.data()!);
  }

  Future<void> deleteGroup(String code) async {
    await _groupsRef.doc(code).delete();
  }

  SubscriptionGroup _toGroup(Map<String, dynamic> data) {
    return SubscriptionGroup(
      code: data['code'] as String,
      name: data['name'] as String,
      ownerId: data['ownerId'] as String,
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

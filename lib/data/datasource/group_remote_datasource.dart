import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subby/data/dto/group_dto.dart';
import 'package:subby/data/mapper/group_mapper.dart';
import 'package:subby/data/response/group_response.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  Future<void> saveGroup(GroupDto dto) async {
    final response = GroupResponse(
      code: dto.code,
      name: dto.name,
      ownerId: dto.ownerId,
      members: dto.members,
      createdAt: dto.createdAt.millisecondsSinceEpoch,
      updatedAt: dto.updatedAt?.millisecondsSinceEpoch,
    );

    await _groupsRef.doc(dto.code).set(response.toJson());
  }

  Future<GroupDto?> fetchGroup(String code) async {
    final doc = await _groupsRef.doc(code).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final response = _toResponse(doc.data()!);

    return response.toDto();
  }

  Future<void> deleteGroup(String code) async {
    await _groupsRef.doc(code).delete();
  }

  Future<void> leaveGroup(String code, String userId) async {
    final doc = await _groupsRef.doc(code).get();

    if (!doc.exists || doc.data() == null) return;

    final data = doc.data()!;
    final members = List<String>.from(data['members'] is Map
        ? (data['members'] as Map).keys
        : data['members'] ?? []);

    if (members.length <= 1) {
      await deleteGroup(code);
      return;
    }

    members.remove(userId);
    final updates = <String, dynamic>{
      'members': {for (var uid in members) uid: true},
    };

    if (data['ownerId'] == userId && members.isNotEmpty) {
      updates['ownerId'] = members.first;
    }

    await _groupsRef.doc(code).update(updates);
  }

  GroupResponse _toResponse(Map<String, dynamic> data) {
    List<String> memberList = [];

    if (data['members'] != null) {
      if (data['members'] is Map) {
        memberList = (data['members'] as Map).keys.cast<String>().toList();
      } else if (data['members'] is List) {
        memberList = List<String>.from(data['members']);
      }
    }

    return GroupResponse(
      code: data['code'] as String,
      name: data['name'] as String,
      ownerId: data['ownerId'] as String,
      members: memberList,
      createdAt: data['createdAt'] as int,
      updatedAt: data['updatedAt'] as int?,
    );
  }
}

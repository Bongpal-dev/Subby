import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subby/data/dto/group_dto.dart';
import 'package:subby/data/mapper/group_mapper.dart';
import 'package:subby/data/response/group_response.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  Future<void> saveGroup(GroupDto dto, {String? ownerNickname}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final membersWithJoinedAt = {
      for (var uid in dto.members)
        uid: {
          'joinedAt': now,
          if (ownerNickname != null && uid == dto.ownerId) 'nickname': ownerNickname,
        }
    };

    final data = {
      'code': dto.code,
      'name': dto.name,
      'ownerId': dto.ownerId,
      'members': membersWithJoinedAt,
      'memberUids': dto.members,
      'createdAt': dto.createdAt.millisecondsSinceEpoch,
      if (dto.updatedAt != null)
        'updatedAt': dto.updatedAt!.millisecondsSinceEpoch,
    };

    await _groupsRef.doc(dto.code).set(data);
  }

  Future<GroupDto?> fetchGroup(String code) async {
    final doc = await _groupsRef.doc(code).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final response = _toResponse(doc.data()!);

    return response.toDto();
  }

  Stream<GroupDto?> watchGroup(String code) {
    return _groupsRef.doc(code).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final response = _toResponse(doc.data()!);

      return response.toDto();
    });
  }

  Future<void> deleteGroup(String code) async {
    await _groupsRef.doc(code).delete();
  }

  Future<void> leaveGroup(String code, String userId) async {
    final doc = await _groupsRef.doc(code).get();

    if (!doc.exists || doc.data() == null) return;

    final data = doc.data()!;
    final membersRaw = data['members'];

    if (membersRaw is! Map) return;

    final membersMap = Map<String, dynamic>.from(membersRaw);

    if (membersMap.length <= 1) {
      await deleteGroup(code);
      return;
    }

    membersMap.remove(userId);

    final updates = <String, dynamic>{
      'members': membersMap,
      'memberUids': FieldValue.arrayRemove([userId]),
    };

    if (data['ownerId'] == userId && membersMap.isNotEmpty) {
      final oldestMember = _findOldestMember(membersMap);

      updates['ownerId'] = oldestMember;
    }

    await _groupsRef.doc(code).update(updates);
  }

  String _findOldestMember(Map<String, dynamic> membersMap) {
    String? oldestUid;
    int oldestJoinedAt = double.maxFinite.toInt();

    for (final entry in membersMap.entries) {
      final uid = entry.key;
      final value = entry.value;

      int joinedAt;

      if (value is Map && value['joinedAt'] != null) {
        joinedAt = value['joinedAt'] as int;
      } else {
        joinedAt = 0;
      }

      if (joinedAt < oldestJoinedAt) {
        oldestJoinedAt = joinedAt;
        oldestUid = uid;
      }
    }

    return oldestUid ?? membersMap.keys.first;
  }

  Future<void> addMember(String code, String userId, {String? nickname}) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await _groupsRef.doc(code).update({
      'members.$userId': {
        'joinedAt': now,
        if (nickname != null) 'nickname': nickname,
      },
      'memberUids': FieldValue.arrayUnion([userId]),
    });
  }

  Future<List<GroupDto>> fetchGroupsByUserId(String userId) async {
    final snapshot = await _groupsRef
        .where('memberUids', arrayContains: userId)
        .get();

    return snapshot.docs
        .where((doc) => doc.data().isNotEmpty)
        .map((doc) => _toResponse(doc.data()).toDto())
        .toList();
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

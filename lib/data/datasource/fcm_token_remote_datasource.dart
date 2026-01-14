import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FcmTokenRemoteDataSource {
  final FirebaseFirestore _firestore;

  FcmTokenRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userRef(String userId) =>
      _firestore.collection('users').doc(userId);

  /// FCM 토큰 저장
  Future<void> saveToken({
    required String userId,
    required String token,
  }) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';

    await _userRef(userId).set({
      'fcmTokens': {
        token: {
          'platform': platform,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      },
    }, SetOptions(merge: true));
  }

  /// FCM 토큰 삭제
  Future<void> deleteToken({
    required String userId,
    required String token,
  }) async {
    await _userRef(userId).update({
      'fcmTokens.$token': FieldValue.delete(),
    });
  }

  /// 사용자가 속한 그룹 목록 저장 (푸시 알림 대상 판단용)
  Future<void> saveUserGroup({
    required String userId,
    required String groupCode,
  }) async {
    await _userRef(userId).set({
      'groups': FieldValue.arrayUnion([groupCode]),
    }, SetOptions(merge: true));
  }

  /// 그룹에서 나갈 때 그룹 코드 제거
  Future<void> removeUserGroup({
    required String userId,
    required String groupCode,
  }) async {
    await _userRef(userId).update({
      'groups': FieldValue.arrayRemove([groupCode]),
    });
  }
}

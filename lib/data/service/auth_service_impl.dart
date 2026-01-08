import 'package:firebase_auth/firebase_auth.dart';
import 'package:subby/domain/service/auth_service.dart';

/// Firebase Anonymous Auth 구현
class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;

  AuthServiceImpl({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Stream<String?> get authStateChanges {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  @override
  Future<String> signInAnonymously() async {
    try {
      // 이미 로그인된 경우 기존 UID 반환
      if (_auth.currentUser != null) {
        return _auth.currentUser!.uid;
      }

      final credential = await _auth.signInAnonymously();
      return credential.user!.uid;
    } catch (e) {
      throw Exception('Firebase 익명 로그인 실패: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

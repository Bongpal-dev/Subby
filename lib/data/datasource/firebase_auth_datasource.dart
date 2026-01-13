import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  static const _localUserIdKey = 'local_user_id';

  FirebaseAuthDataSource({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<String?> get authStateChanges {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  Future<String> signInAnonymously() async {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid;
    }

    try {
      final credential = await _auth.signInAnonymously();
      return credential.user!.uid;
    } catch (e) {
      return _getOrCreateLocalUserId();
    }
  }

  Future<String> _getOrCreateLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var localUserId = prefs.getString(_localUserIdKey);

    if (localUserId == null) {
      localUserId = const Uuid().v4();
      await prefs.setString(_localUserIdKey, localUserId);
    }

    return localUserId;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

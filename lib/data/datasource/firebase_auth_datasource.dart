import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Google 로그인 결과
sealed class GoogleSignInResult {}

class GoogleSignInSuccess extends GoogleSignInResult {
  final String userId;
  final String? email;
  final bool isNewUser;

  GoogleSignInSuccess({
    required this.userId,
    this.email,
    this.isNewUser = false,
  });
}

class GoogleSignInCancelled extends GoogleSignInResult {}

class GoogleSignInError extends GoogleSignInResult {
  final String code;
  final String message;

  GoogleSignInError({required this.code, required this.message});
}

/// 계정 연결(link) 결과
sealed class LinkAccountResult {}

class LinkSuccess extends LinkAccountResult {
  final String userId;
  final String? email;

  LinkSuccess({required this.userId, this.email});
}

class LinkCancelled extends LinkAccountResult {}

class LinkCredentialAlreadyInUse extends LinkAccountResult {
  final String? email;
  final AuthCredential credential;

  LinkCredentialAlreadyInUse({this.email, required this.credential});
}

class LinkError extends LinkAccountResult {
  final String code;
  final String message;

  LinkError({required this.code, required this.message});
}

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  static const _localUserIdKey = 'local_user_id';

  FirebaseAuthDataSource({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  String? get currentUserId => _auth.currentUser?.uid;

  User? get currentUser => _auth.currentUser;

  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  String? get currentEmail => _auth.currentUser?.email;

  Stream<String?> get authStateChanges {
    return _auth.authStateChanges().map((user) => user?.uid);
  }

  Stream<User?> get userChanges => _auth.userChanges();

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
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Google 로그인 (새 로그인 또는 기존 계정)
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return GoogleSignInCancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      return GoogleSignInSuccess(
        userId: userCredential.user!.uid,
        email: userCredential.user?.email,
        isNewUser: isNewUser,
      );
    } on FirebaseAuthException catch (e) {
      return GoogleSignInError(code: e.code, message: e.message ?? '');
    } catch (e) {
      return GoogleSignInError(code: 'unknown', message: e.toString());
    }
  }

  /// 익명 계정에 Google 계정 연결
  Future<LinkAccountResult> linkWithGoogle() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return LinkError(code: 'no-user', message: '로그인된 사용자가 없습니다.');
    }

    if (!currentUser.isAnonymous) {
      return LinkError(
        code: 'not-anonymous',
        message: '이미 Google 계정으로 로그인되어 있습니다.',
      );
    }

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return LinkCancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await currentUser.linkWithCredential(credential);
      return LinkSuccess(
        userId: userCredential.user!.uid,
        email: userCredential.user?.email,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        // 이미 다른 계정에서 사용 중인 Google 계정
        final googleUser = _googleSignIn.currentUser;
        final googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        return LinkCredentialAlreadyInUse(
          email: googleUser?.email,
          credential: credential,
        );
      }
      return LinkError(code: e.code, message: e.message ?? '');
    } catch (e) {
      return LinkError(code: 'unknown', message: e.toString());
    }
  }

  /// 기존 Google 계정으로 로그인 (익명 데이터 포기)
  Future<GoogleSignInResult> signInWithExistingGoogle(
    AuthCredential credential,
  ) async {
    try {
      // 기존 익명 계정 로그아웃
      await _auth.signOut();

      // Google 계정으로 로그인
      final userCredential = await _auth.signInWithCredential(credential);
      return GoogleSignInSuccess(
        userId: userCredential.user!.uid,
        email: userCredential.user?.email,
        isNewUser: false,
      );
    } on FirebaseAuthException catch (e) {
      return GoogleSignInError(code: e.code, message: e.message ?? '');
    } catch (e) {
      return GoogleSignInError(code: 'unknown', message: e.toString());
    }
  }

  /// Google 로그아웃만 (Firebase 로그아웃 없이)
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}

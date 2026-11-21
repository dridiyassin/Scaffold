import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_service.dart';

/// Wraps FirebaseAuth: e-mail/password and Google Sign-In.
class AuthService {
  AuthService(this._users, {FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _google = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  final UserService _users;
  Future<void>? _googleInit;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(displayName.trim());
    await _users.ensureProfile(user, displayName: displayName.trim());
    return credential;
  }

  /// Returns null when the user closes the Google account picker.
  Future<UserCredential?> signInWithGoogle() async {
    // On Android the web client id is read from google-services.json
    // (`default_web_client_id`), so no argument is needed here.
    await (_googleInit ??= _google.initialize());

    final GoogleSignInAccount account;
    try {
      account = await _google.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null;
      }
      rethrow;
    }

    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final result = await _auth.signInWithCredential(credential);
    await _users.ensureProfile(result.user!);
    return result;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() async {
    if (_googleInit != null) {
      try {
        await _google.signOut();
      } catch (_) {
        // Not signed in with Google: nothing to do.
      }
    }
    await _auth.signOut();
  }
}

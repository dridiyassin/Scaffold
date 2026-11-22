import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

enum SessionStatus { unknown, signedOut, signedIn }

/// Current signed-in user and their live Firestore profile.
class SessionProvider extends ChangeNotifier {
  SessionProvider(this._auth, this._users) {
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final AuthService _auth;
  final UserService _users;
  late final StreamSubscription<User?> _authSub;
  StreamSubscription<AppUser?>? _profileSub;
  final _ready = Completer<void>();

  SessionStatus _status = SessionStatus.unknown;
  AppUser? _profile;

  SessionStatus get status => _status;

  /// Live profile document (null while loading or signed out).
  AppUser? get profile => _profile;

  /// Always up to date, even before the auth stream has fired.
  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;

  /// Completes once the initial auth state is known.
  Future<void> get ready => _ready.future;

  Future<void> _onAuthChanged(User? user) async {
    await _profileSub?.cancel();
    _profileSub = null;
    _profile = null;

    if (user == null) {
      _setStatus(SessionStatus.signedOut);
      return;
    }
    try {
      await _users.ensureProfile(user);
    } catch (_) {
      // Offline: the profile stream below will catch up later.
    }
    _profileSub = _users.watch(user.uid).listen((p) {
      _profile = p;
      notifyListeners();
    }, onError: (Object _) {});
    _setStatus(SessionStatus.signedIn);
  }

  void _setStatus(SessionStatus status) {
    _status = status;
    if (!_ready.isCompleted) _ready.complete();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

/// Reads and writes creator profiles in `users/{uid}`.
class UserService {
  UserService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Stream<AppUser?> watch(String uid) => _users
      .doc(uid)
      .snapshots()
      .map((doc) => doc.exists ? AppUser.fromDoc(doc) : null);

  Future<AppUser?> fetch(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists ? AppUser.fromDoc(doc) : null;
  }

  /// Creates the profile document on first sign-in. When it already exists
  /// only the display name is refreshed (if one is given).
  Future<void> ensureProfile(User user, {String? displayName}) async {
    final ref = _users.doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) {
      if (displayName != null) {
        await ref.update({'displayName': displayName});
      }
      return;
    }
    final name =
        displayName ??
        user.displayName ??
        user.email?.split('@').first ??
        'Creator';
    await ref.set({
      'displayName': name,
      'username': _usernameFrom(name, user.uid),
      'email': user.email ?? '',
      'photoUrl': user.photoURL,
      'bio': '',
      'points': 0,
      'creationsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// "Ada Lovelace" + uid -> "ada_lovelace_k3f9".
  static String _usernameFrom(String name, String uid) {
    final base = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final safe = base.isEmpty ? 'creator' : base;
    final cut = safe.length > 16 ? safe.substring(0, 16) : safe;
    return '${cut}_${uid.substring(0, 4).toLowerCase()}';
  }
}

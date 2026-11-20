import 'package:cloud_firestore/cloud_firestore.dart';

/// Public profile of a creator, stored in `users/{uid}`.
class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bio = '',
    this.points = 0,
    this.creationsCount = 0,
    this.createdAt,
  });

  final String uid;
  final String displayName;
  final String username;
  final String email;
  final String? photoUrl;
  final String bio;

  /// Gamification score (see `PointsRules`).
  final int points;
  final int creationsCount;
  final DateTime? createdAt;

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const <String, dynamic>{};
    return AppUser(
      uid: doc.id,
      displayName: d['displayName'] as String? ?? '',
      username: d['username'] as String? ?? '',
      email: d['email'] as String? ?? '',
      photoUrl: d['photoUrl'] as String?,
      bio: d['bio'] as String? ?? '',
      points: (d['points'] as num?)?.toInt() ?? 0,
      creationsCount: (d['creationsCount'] as num?)?.toInt() ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

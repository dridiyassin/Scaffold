import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/gamification.dart';
import '../models/app_user.dart';
import '../models/creation.dart';

enum FeedSort { trending, latest }

/// All Firestore access for creations, likes, evolutions and points.
///
/// Data layout:
/// * `creations/{id}`               – a creation (see [Creation])
/// * `creations/{id}/likes/{uid}`   – one doc per user who liked it
/// * `users/{uid}.points`           – updated in the same batch/transaction
class CreationService {
  CreationService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _creations =>
      _db.collection('creations');

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  // ---------------------------------------------------------------- reads --

  /// One-shot load for the vertical feed (a live query would reorder pages
  /// while the user is swiping).
  Future<List<Creation>> fetchFeed(FeedSort sort, {int limit = 50}) async {
    final query = switch (sort) {
      FeedSort.trending => _creations.orderBy('likesCount', descending: true),
      FeedSort.latest => _creations.orderBy('createdAt', descending: true),
    };
    final snap = await query.limit(limit).get();
    return snap.docs.map(Creation.fromDoc).toList();
  }

  Stream<Creation?> watch(String id) => _creations
      .doc(id)
      .snapshots()
      .map((doc) => doc.exists ? Creation.fromDoc(doc) : null);

  Future<Creation?> fetch(String id) async {
    final doc = await _creations.doc(id).get();
    return doc.exists ? Creation.fromDoc(doc) : null;
  }

  /// Every creation of a user, newest first. Sorted client-side so no
  /// composite index is needed.
  Stream<List<Creation>> byAuthor(String uid) => _creations
      .where('authorId', isEqualTo: uid)
      .snapshots()
      .map((s) => _newestFirst(s.docs.map(Creation.fromDoc)));

  /// Direct evolutions (children) of a creation, newest first.
  Stream<List<Creation>> evolutionsOf(String id) => _creations
      .where('parentId', isEqualTo: id)
      .snapshots()
      .map((s) => _newestFirst(s.docs.map(Creation.fromDoc)));

  /// The lineage of [creation]: root first, direct parent last.
  /// Deleted ancestors are skipped.
  Future<List<Creation>> fetchAncestors(Creation creation) async {
    final ids = creation.ancestorIds;
    if (ids.isEmpty) return const [];
    final found = <String, Creation>{};
    for (var i = 0; i < ids.length; i += 30) {
      final chunk = ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30);
      final snap = await _creations
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        found[doc.id] = Creation.fromDoc(doc);
      }
    }
    return [
      for (final id in ids)
        if (found[id] != null) found[id]!,
    ];
  }

  Stream<bool> isLikedBy(String creationId, String uid) => _creations
      .doc(creationId)
      .collection('likes')
      .doc(uid)
      .snapshots()
      .map((d) => d.exists);

  // --------------------------------------------------------------- writes --

  /// Likes or unlikes, keeping `likesCount` and the author's points in sync.
  /// Returns the new liked state.
  Future<bool> toggleLike(Creation creation, String uid) {
    final creationRef = _creations.doc(creation.id);
    final likeRef = creationRef.collection('likes').doc(uid);
    final rewardAuthor = creation.authorId != uid;

    return _db.runTransaction<bool>((tx) async {
      final like = await tx.get(likeRef);
      final delta = like.exists ? -1 : 1;
      if (like.exists) {
        tx.delete(likeRef);
      } else {
        tx.set(likeRef, {'createdAt': FieldValue.serverTimestamp()});
      }
      tx.update(creationRef, {'likesCount': FieldValue.increment(delta)});
      if (rewardAuthor) {
        tx.update(_users.doc(creation.authorId), {
          'points': FieldValue.increment(delta * PointsRules.likeReceived),
        });
      }
      return !like.exists;
    });
  }

  /// Best-effort view counter (no points for views).
  Future<void> registerView(String id) async {
    try {
      await _creations.doc(id).update({'viewsCount': FieldValue.increment(1)});
    } catch (_) {
      // Ignored: a missed view must never break the UI.
    }
  }

  /// Publishes an original (`parent == null`) or an evolution of [parent].
  ///
  /// In a single atomic batch it also:
  /// * gives the author [PointsRules.publish] points,
  /// * increments the parent's `forksCount`,
  /// * increments `descendantsCount` on every ancestor,
  /// * rewards the parent's author ([PointsRules.directEvolution]) and every
  ///   other ancestor's author ([PointsRules.ancestorEvolution]).
  ///
  /// Part 2 (the editor screen) only has to call this method.
  Future<String> publish({
    required AppUser author,
    required String title,
    required String description,
    required String code,
    required CreationCategory category,
    List<String> tags = const [],
    Creation? parent,
  }) async {
    final ref = _creations.doc();
    final ancestorIds = [...?parent?.ancestorIds, ?parent?.id];
    final ancestorAuthorIds = [
      ...?parent?.ancestorAuthorIds,
      ?parent?.authorId,
    ];

    final batch = _db.batch();
    batch.set(ref, {
      'title': title.trim(),
      'description': description.trim(),
      'code': code,
      'category': category.name,
      'tags': tags,
      'authorId': author.uid,
      'authorName': author.displayName,
      'authorUsername': author.username,
      'authorPhotoUrl': author.photoUrl,
      'parentId': parent?.id,
      'parentTitle': parent?.title,
      'parentAuthorId': parent?.authorId,
      'parentAuthorName': parent?.authorName,
      'rootId': parent?.rootId ?? ref.id,
      'ancestorIds': ancestorIds,
      'ancestorAuthorIds': ancestorAuthorIds,
      'likesCount': 0,
      'forksCount': 0,
      'descendantsCount': 0,
      'viewsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(_users.doc(author.uid), {
      'points': FieldValue.increment(PointsRules.publish),
      'creationsCount': FieldValue.increment(1),
    });

    if (parent != null) {
      final rewards = <String, int>{};
      for (var i = 0; i < ancestorIds.length; i++) {
        final isParent = i == ancestorIds.length - 1;
        batch.update(_creations.doc(ancestorIds[i]), {
          'descendantsCount': FieldValue.increment(1),
          if (isParent) 'forksCount': FieldValue.increment(1),
        });
        final ancestorAuthor = ancestorAuthorIds[i];
        if (ancestorAuthor == author.uid) continue;
        rewards[ancestorAuthor] =
            (rewards[ancestorAuthor] ?? 0) +
            (isParent
                ? PointsRules.directEvolution
                : PointsRules.ancestorEvolution);
      }
      rewards.forEach((uid, points) {
        batch.update(_users.doc(uid), {'points': FieldValue.increment(points)});
      });
    }

    await batch.commit();
    return ref.id;
  }

  static List<Creation> _newestFirst(Iterable<Creation> items) {
    final list = items.toList();
    // Pending server timestamps are null: treat them as "just now".
    final now = DateTime.now();
    list.sort((a, b) => (b.createdAt ?? now).compareTo(a.createdAt ?? now));
    return list;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// Kind of software a creation is. Stored as its [name] in Firestore.
enum CreationCategory {
  game,
  website,
  tool,
  simulation,
  app,
  art;

  static CreationCategory fromName(String? name) => values.firstWhere(
    (c) => c.name == name,
    orElse: () => CreationCategory.app,
  );
}

/// A published piece of software (single self-contained HTML document).
///
/// Every creation is a node in an evolution tree:
/// * an *original* has no parent and is the root of its own tree;
/// * an *evolution* (fork) points to its [parentId] and keeps the full chain
///   of [ancestorIds] (root first, direct parent last) so the lineage can be
///   shown without walking the tree.
class Creation {
  const Creation({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.category,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.rootId,
    this.authorPhotoUrl,
    this.tags = const [],
    this.parentId,
    this.parentTitle,
    this.parentAuthorId,
    this.parentAuthorName,
    this.ancestorIds = const [],
    this.ancestorAuthorIds = const [],
    this.likesCount = 0,
    this.forksCount = 0,
    this.descendantsCount = 0,
    this.viewsCount = 0,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;

  /// Full HTML document (HTML + CSS + JS) rendered in a sandboxed WebView.
  final String code;
  final CreationCategory category;
  final List<String> tags;

  final String authorId;
  final String authorName;
  final String authorUsername;
  final String? authorPhotoUrl;

  /// Direct parent this creation was evolved from (null for originals).
  final String? parentId;
  final String? parentTitle;
  final String? parentAuthorId;
  final String? parentAuthorName;

  /// Id of the original creation at the top of this tree.
  final String rootId;

  /// Lineage, root first and direct parent last. Empty for originals.
  final List<String> ancestorIds;

  /// Author of each entry in [ancestorIds] (same order), used to reward
  /// ancestors when a new evolution is published.
  final List<String> ancestorAuthorIds;

  final int likesCount;

  /// Number of direct evolutions (children).
  final int forksCount;

  /// Number of evolutions anywhere below this creation in the tree.
  final int descendantsCount;
  final int viewsCount;
  final DateTime? createdAt;

  bool get isOriginal => parentId == null;

  /// 0 for originals, 1 for a direct evolution of an original, …
  int get depth => ancestorIds.length;

  /// Human friendly generation number (originals are generation 1).
  int get generation => depth + 1;

  factory Creation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const <String, dynamic>{};
    List<String> strings(Object? v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? const [];
    int integer(Object? v) => (v as num?)?.toInt() ?? 0;

    return Creation(
      id: doc.id,
      title: d['title'] as String? ?? '',
      description: d['description'] as String? ?? '',
      code: d['code'] as String? ?? '',
      category: CreationCategory.fromName(d['category'] as String?),
      tags: strings(d['tags']),
      authorId: d['authorId'] as String? ?? '',
      authorName: d['authorName'] as String? ?? '',
      authorUsername: d['authorUsername'] as String? ?? '',
      authorPhotoUrl: d['authorPhotoUrl'] as String?,
      parentId: d['parentId'] as String?,
      parentTitle: d['parentTitle'] as String?,
      parentAuthorId: d['parentAuthorId'] as String?,
      parentAuthorName: d['parentAuthorName'] as String?,
      rootId: d['rootId'] as String? ?? doc.id,
      ancestorIds: strings(d['ancestorIds']),
      ancestorAuthorIds: strings(d['ancestorAuthorIds']),
      likesCount: integer(d['likesCount']),
      forksCount: integer(d['forksCount']),
      descendantsCount: integer(d['descendantsCount']),
      viewsCount: integer(d['viewsCount']),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

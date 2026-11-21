import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold/core/gamification.dart';
import 'package:scaffold/models/app_user.dart';
import 'package:scaffold/models/creation.dart';
import 'package:scaffold/services/creation_service.dart';

void main() {
  late FakeFirebaseFirestore db;
  late CreationService service;

  Future<AppUser> createUser(String uid) async {
    await db.collection('users').doc(uid).set({
      'displayName': uid.toUpperCase(),
      'username': uid,
      'email': '$uid@example.com',
      'points': 0,
      'creationsCount': 0,
    });
    return AppUser(
      uid: uid,
      displayName: uid.toUpperCase(),
      username: uid,
      email: '$uid@example.com',
    );
  }

  Future<int> pointsOf(String uid) async =>
      ((await db.collection('users').doc(uid).get()).data()!['points'] as num)
          .toInt();

  Future<Creation> publish(
    AppUser author,
    String title, {
    Creation? parent,
  }) async {
    final id = await service.publish(
      author: author,
      title: title,
      description: 'desc',
      code: '<p>$title</p>',
      category: CreationCategory.game,
      parent: parent,
    );
    return (await service.fetch(id))!;
  }

  setUp(() {
    db = FakeFirebaseFirestore();
    service = CreationService(firestore: db);
  });

  test('evolutions build the lineage and reward every ancestor', () async {
    final ada = await createUser('ada');
    final bob = await createUser('bob');
    final cy = await createUser('cy');

    final root = await publish(ada, 'Root');
    expect(root.isOriginal, isTrue);
    expect(root.rootId, root.id);
    expect(root.generation, 1);

    final child = await publish(bob, 'Child', parent: root);
    expect(child.parentId, root.id);
    expect(child.parentTitle, 'Root');
    expect(child.rootId, root.id);
    expect(child.ancestorIds, [root.id]);
    expect(child.generation, 2);

    final grandchild = await publish(cy, 'Grandchild', parent: child);
    expect(grandchild.rootId, root.id);
    expect(grandchild.ancestorIds, [root.id, child.id]);
    expect(grandchild.ancestorAuthorIds, ['ada', 'bob']);
    expect(grandchild.generation, 3);

    final rootNow = (await service.fetch(root.id))!;
    expect(rootNow.forksCount, 1);
    expect(rootNow.descendantsCount, 2);
    final childNow = (await service.fetch(child.id))!;
    expect(childNow.forksCount, 1);
    expect(childNow.descendantsCount, 1);

    expect(
      await pointsOf('ada'),
      PointsRules.publish +
          PointsRules.directEvolution +
          PointsRules.ancestorEvolution,
    );
    expect(
      await pointsOf('bob'),
      PointsRules.publish + PointsRules.directEvolution,
    );
    expect(await pointsOf('cy'), PointsRules.publish);

    final ancestors = await service.fetchAncestors(grandchild);
    expect(ancestors.map((c) => c.title), ['Root', 'Child']);
    final evolutions = await service.evolutionsOf(root.id).first;
    expect(evolutions.map((c) => c.id), [child.id]);
    final byAda = await service.byAuthor('ada').first;
    expect(byAda.map((c) => c.id), [root.id]);
  });

  test('evolving your own creation gives no evolution points', () async {
    final ada = await createUser('ada');
    final root = await publish(ada, 'Root');
    await publish(ada, 'My own fork', parent: root);

    expect(await pointsOf('ada'), 2 * PointsRules.publish);
  });

  test('likes toggle, keep counts in sync and only reward others', () async {
    final ada = await createUser('ada');
    await createUser('bob');
    final root = await publish(ada, 'Root');

    expect(await service.toggleLike(root, 'bob'), isTrue);
    expect((await service.fetch(root.id))!.likesCount, 1);
    expect(await service.isLikedBy(root.id, 'bob').first, isTrue);
    expect(
      await pointsOf('ada'),
      PointsRules.publish + PointsRules.likeReceived,
    );

    expect(await service.toggleLike(root, 'bob'), isFalse);
    expect((await service.fetch(root.id))!.likesCount, 0);
    expect(await pointsOf('ada'), PointsRules.publish);

    // Liking your own creation counts the like but gives no points.
    expect(await service.toggleLike(root, 'ada'), isTrue);
    expect((await service.fetch(root.id))!.likesCount, 1);
    expect(await pointsOf('ada'), PointsRules.publish);
  });

  test('trending feed is ordered by likes', () async {
    final ada = await createUser('ada');
    await createUser('bob');
    final quiet = await publish(ada, 'Quiet');
    final popular = await publish(ada, 'Popular');
    await service.toggleLike(popular, 'bob');

    final trending = await service.fetchFeed(FeedSort.trending);
    expect(trending.map((c) => c.id), [popular.id, quiet.id]);
  });
}

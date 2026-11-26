import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold/app.dart';
import 'package:scaffold/app_providers.dart';
import 'package:scaffold/l10n/app_localizations.dart';
import 'package:scaffold/models/app_user.dart';
import 'package:scaffold/services/creation_service.dart';
import 'package:scaffold/services/demo_seed.dart';
import 'package:scaffold/screens/auth/login_screen.dart';
import 'package:scaffold/screens/creation/creation_detail_screen.dart';
import 'package:scaffold/screens/feed/feed_item.dart';
import 'package:scaffold/screens/home/home_shell.dart';
import 'package:scaffold/screens/settings/settings_screen.dart';
import 'package:scaffold/widgets/creation_card.dart';
import 'package:scaffold/widgets/like_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'support/fake_webview.dart';

/// End-to-end flows of Part 1 on a phone-sized screen, with an in-memory
/// Firestore, a mocked FirebaseAuth and a fake WebView.
void main() {
  late FakeWebViewPlatform webviews;

  setUp(() {
    webviews = FakeWebViewPlatform();
    WebViewPlatform.instance = webviews;
  });

  /// Advances fake time in small steps (pumpAndSettle would never finish
  /// while a progress indicator spins).
  Future<void> settle(WidgetTester tester, [int ms = 1000]) async {
    for (var t = 0; t < ms; t += 100) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<FakeFirebaseFirestore> pumpApp(
    WidgetTester tester, {
    required MockFirebaseAuth auth,
    Map<String, Object> prefs = const {},
    FakeFirebaseFirestore? firestore,
    Size screen = const Size(1080, 2340),
  }) async {
    tester.view.physicalSize = screen;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(prefs);
    final sharedPrefs = await SharedPreferences.getInstance();
    final db = firestore ?? FakeFirebaseFirestore();
    await tester.pumpWidget(
      AppProviders(
        prefs: sharedPrefs,
        firestore: db,
        auth: auth,
        child: const ScaffoldApp(firebaseError: null),
      ),
    );
    await settle(tester, 2500); // splash animation + auth restore
    return db;
  }

  MockFirebaseAuth signedInAuth() => MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(
      uid: 'ada-uid',
      email: 'ada@example.com',
      displayName: 'Ada Lovelace',
    ),
  );

  Finder bottomTab(String label) => find.descendant(
    of: find.byType(BottomNavigationBar),
    matching: find.text(label),
  );

  testWidgets('signed-out user lands on the login screen', (tester) async {
    await pumpApp(tester, auth: MockFirebaseAuth());

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sign in to Scaffold'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('register creates the profile and opens the home feed', (
    tester,
  ) async {
    final db = await pumpApp(tester, auth: MockFirebaseAuth());

    await tester.tap(find.text('Sign up'));
    await settle(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Grace Hopper');
    await tester.enterText(fields.at(1), 'grace@example.com');
    await tester.enterText(fields.at(2), 'cobol1959');
    await tester.enterText(fields.at(3), 'cobol1959');
    final terms = find.byType(CheckboxListTile);
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    final submit = find.widgetWithText(FilledButton, 'Create account');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await settle(tester, 2000);

    expect(find.byType(HomeShell), findsOneWidget);
    expect(find.text('No creations yet'), findsOneWidget);
    final users = await db.collection('users').get();
    expect(users.docs, hasLength(1));
    expect(users.docs.single['displayName'], 'Grace Hopper');
    expect(users.docs.single['points'], 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'demo creations fill the feed; likes, profile lineage and detail work',
    (tester) async {
      final db = await pumpApp(tester, auth: signedInAuth());

      // Empty feed -> load demo creations from the empty state.
      expect(find.byType(HomeShell), findsOneWidget);
      expect(find.text('No creations yet'), findsOneWidget);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Load demo creations'),
      );
      await settle(tester, 3000);

      expect(find.byType(FeedItem), findsOneWidget);
      expect(
        webviews.loadedHtml,
        isNotEmpty,
        reason: 'active page runs its code',
      );
      final user = await db.collection('users').doc('ada-uid').get();
      expect(user['points'], 30, reason: '6 publications x 5 points');
      expect(user['creationsCount'], 6);

      // Like the creation on screen.
      await tester.tap(find.byType(LikeButton));
      await settle(tester);
      final liked = await db
          .collection('creations')
          .where('likesCount', isEqualTo: 1)
          .get();
      expect(liked.docs, hasLength(1));

      // Profile: originals vs branches, with "based on" lineage.
      await tester.tap(bottomTab('Profile'));
      await settle(tester, 2000);
      expect(find.text('30 pts'), findsOneWidget);
      expect(find.text('Originals (3)'), findsOneWidget);
      expect(find.text('Branches (3)'), findsOneWidget);

      await tester.tap(find.text('Branches (3)'));
      await settle(tester);
      final branchList = find.descendant(
        of: find.byKey(const PageStorageKey<String>('evolutions')),
        matching: find.byType(Scrollable),
      );
      expect(
        find.text('Branch of Rainbow Snake by Ada Lovelace · Gen 3'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Branch of Neon Snake by Ada Lovelace · Gen 2'),
        150,
        scrollable: branchList.first,
      );
      expect(
        find.text('Branch of Neon Snake by Ada Lovelace · Gen 2'),
        findsOneWidget,
      );

      // Open the generation-3 creation and check its lineage tab.
      await tester.scrollUntilVisible(
        find.text('Rainbow Snake Turbo'),
        -150,
        scrollable: branchList.first,
      );
      await tester.tap(find.text('Rainbow Snake Turbo'));
      await settle(tester, 1500);
      expect(find.byType(CreationDetailScreen), findsOneWidget);
      expect(
        find.byType(BottomNavigationBar),
        findsOneWidget,
        reason: 'nested navigation keeps the bottom bar',
      );
      await tester.tap(find.text('Lineage'));
      await settle(tester, 1500);
      expect(find.text('Gen 3 · You are here'), findsOneWidget);
      expect(find.text('Neon Snake'), findsOneWidget);
      expect(find.text('Rainbow Snake'), findsOneWidget);

      // Back to the profile.
      await tester.tap(find.byType(BackButton));
      await settle(tester);
      expect(find.byType(CreationDetailScreen), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('settings switch to Arabic (RTL) and dark theme, persisted', (
    tester,
  ) async {
    await pumpApp(tester, auth: signedInAuth());

    await tester.tap(bottomTab('Profile'));
    await settle(tester);
    await tester.tap(find.byTooltip('Settings'));
    await settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await settle(tester);
    await tester.tap(find.text('العربية'));
    await settle(tester);

    final context = tester.element(find.byType(SettingsScreen));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(find.text('الإعدادات'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale'), 'ar');
    expect(prefs.getString('theme_mode'), 'dark');
    expect(tester.takeException(), isNull);
  });

  // Visits every Part 1 screen in each language on a small 360x640 phone.
  // Any overflow or exception fails the test.
  for (final locale in ['en', 'fr', 'ar']) {
    testWidgets('screen tour without layout errors [$locale]', (tester) async {
      final db = FakeFirebaseFirestore();
      await db.collection('users').doc('ada-uid').set({
        'displayName': 'Ada Lovelace',
        'username': 'ada_lovelace_ada',
        'email': 'ada@example.com',
        'bio': 'First programmer. Writes poetry about engines and branches.',
        'points': 0,
        'creationsCount': 0,
      });
      await DemoSeed(CreationService(firestore: db)).run(
        const AppUser(
          uid: 'ada-uid',
          displayName: 'Ada Lovelace',
          username: 'ada_lovelace_ada',
          email: 'ada@example.com',
        ),
      );

      await pumpApp(
        tester,
        auth: signedInAuth(),
        firestore: db,
        prefs: {'locale': locale},
        screen: const Size(1080, 1920),
      );
      final home = tester.element(find.byType(HomeShell));
      final l10n = AppLocalizations.of(home);
      expect(
        Directionality.of(home),
        locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );

      // Feed (Trending, then Latest).
      expect(find.byType(FeedItem), findsOneWidget);
      await tester.tap(find.text(l10n.feedLatest));
      await settle(tester, 1500);
      expect(find.byType(FeedItem), findsOneWidget);
      // Swipe to the next creation.
      await tester.drag(
        find.byWidgetPredicate(
          (w) => w is PageView && w.scrollDirection == Axis.vertical,
        ),
        const Offset(0, -500),
      );
      await settle(tester, 1500);
      expect(find.byType(FeedItem), findsOneWidget);

      // Drawer.
      await tester.tap(find.byTooltip(l10n.menu));
      await settle(tester);
      expect(find.byType(Drawer), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(Drawer),
          matching: find.text(l10n.navExplore),
        ),
      );
      await settle(tester);
      expect(find.text(l10n.comingSoonMessage), findsOneWidget);

      // Remaining tabs: Create (Part 2 editor placeholder), Inbox, Profile.
      await tester.tap(bottomTab(l10n.navCreate));
      await settle(tester);
      expect(find.text(l10n.featureEditor), findsWidgets);
      await tester.tap(find.byType(BackButton));
      await settle(tester);
      await tester.tap(bottomTab(l10n.navInbox));
      await settle(tester);
      await tester.tap(bottomTab(l10n.navProfile));
      await settle(tester, 2000);

      // Points rules sheet (header is visible before scrolling the list).
      await tester.tap(find.byTooltip(l10n.pointsHowTitle));
      await settle(tester);
      expect(find.text(l10n.pointsRuleEvolution(10)), findsOneWidget);
      await tester.tapAt(const Offset(10, 10)); // dismiss the sheet
      await settle(tester);
      expect(find.text(l10n.pointsRuleEvolution(10)), findsNothing);

      await tester.tap(find.text(l10n.profileEvolutions(3)));
      await settle(tester);
      expect(find.byType(CreationCard, skipOffstage: false), findsWidgets);

      // Detail screen: preview, code and lineage tabs. The card may be built
      // in the list's off-screen cache, so scroll it into view first.
      // Collapse the profile header (drag it up) so the list gets the room.
      await tester.dragFrom(const Offset(180, 200), const Offset(0, -500));
      await settle(tester);
      // The same title can also sit on the (hidden) feed tab, so look for
      // it inside a profile card only.
      Finder card({bool skipOffstage = true}) => find.descendant(
        of: find.byType(CreationCard, skipOffstage: skipOffstage),
        matching: find.text('Rainbow Snake Turbo', skipOffstage: skipOffstage),
      );
      await tester.ensureVisible(card(skipOffstage: false));
      await settle(tester);
      await tester.tap(card());
      await settle(tester, 1500);
      expect(find.byType(CreationDetailScreen), findsOneWidget);
      await tester.tap(find.text(l10n.tabCode));
      await settle(tester);
      await tester.tap(find.text(l10n.tabLineage));
      await settle(tester, 1500);
      await tester.tap(find.byType(BackButton));
      await settle(tester);

      // Settings (from the profile app bar).
      await tester.tap(find.byTooltip(l10n.navSettings));
      await settle(tester);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('saved language and theme are restored on startup', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: MockFirebaseAuth(),
      prefs: {'locale': 'fr', 'theme_mode': 'dark'},
    );

    final context = tester.element(find.byType(LoginScreen));
    expect(find.text('Connexion à Scaffold'), findsOneWidget);
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}

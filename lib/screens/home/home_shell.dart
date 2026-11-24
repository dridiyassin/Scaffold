import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n_ext.dart';
import '../../core/routing/app_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../common/coming_soon_screen.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';

enum _HomeTab { feed, explore, create, inbox, profile }

/// Main screen after sign-in: Drawer + BottomNavigationBar.
///
/// Each tab owns a nested [Navigator] (kept alive in an [IndexedStack]) so
/// pushing a creation from the feed keeps the bottom bar visible and every
/// tab remembers its own back stack.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  /// Lets screens inside the nested navigators open the drawer.
  static HomeShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<HomeShellState>();

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKeys = [
    for (final _ in _HomeTab.values) GlobalKey<NavigatorState>(),
  ];

  /// Nested navigators need their own HeroController for Hero animations.
  final _heroControllers = [
    for (final _ in _HomeTab.values) MaterialApp.createMaterialHeroController(),
  ];
  late final _feedObserver = _StackObserver(_onFeedStackChanged);
  int _index = 0;

  /// True while the feed tab shows the feed itself (not a pushed screen).
  bool _feedAtRoot = true;

  void _onFeedStackChanged() {
    // Observers run while the navigator updates: rebuild after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final atRoot =
          !(_navigatorKeys[_HomeTab.feed.index].currentState?.canPop() ??
              false);
      if (atRoot != _feedAtRoot) setState(() => _feedAtRoot = atRoot);
    });
  }

  @override
  void dispose() {
    for (final c in _heroControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void selectTab(int index) {
    final tab = _HomeTab.values[index];
    if (tab == _HomeTab.create) {
      // The editor is a full-screen flow on the root navigator (Part 2).
      Navigator.of(context)
          .pushNamed(AppRoutes.editor, arguments: const EditorArgs());
      return;
    }
    if (index == _index) {
      // Re-tapping the current tab goes back to its first screen.
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => _index = index);
  }

  void _onBack(bool didPop, Object? _) {
    if (didPop) return;
    final nested = _navigatorKeys[_index].currentState;
    if (nested != null && nested.canPop()) {
      nested.pop();
    } else if (_index != _HomeTab.feed.index) {
      setState(() => _index = _HomeTab.feed.index);
    } else {
      SystemNavigator.pop();
    }
  }

  Widget _rootOf(_HomeTab tab) => switch (tab) {
    _HomeTab.feed => const FeedScreen(),
    _HomeTab.explore => const ComingSoonScreen(
      feature: Part2Feature.explore,
      isTabRoot: true,
    ),
    _HomeTab.create => const SizedBox.shrink(),
    _HomeTab.inbox => const ComingSoonScreen(
      feature: Part2Feature.inbox,
      isTabRoot: true,
    ),
    _HomeTab.profile => const ProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Black bar only behind the full-screen feed, themed on pushed screens.
    final onFeed = _index == _HomeTab.feed.index && _feedAtRoot;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onBack,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(currentTab: _index, onSelectTab: selectTab),
        body: IndexedStack(
          index: _index,
          children: [
            for (final tab in _HomeTab.values)
              Navigator(
                key: _navigatorKeys[tab.index],
                observers: [
                  _heroControllers[tab.index],
                  if (tab == _HomeTab.feed) _feedObserver,
                ],
                onGenerateRoute: (settings) =>
                    settings.name == Navigator.defaultRouteName
                    ? MaterialPageRoute<void>(
                        settings: settings,
                        builder: (_) => _rootOf(tab),
                      )
                    : AppRouter.onGenerateRoute(settings),
              ),
          ],
        ),
        // Dark bar on the feed, themed elsewhere; a hairline on top
        // instead of a shadow.
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: onFeed
                    ? Colors.white12
                    : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: selectTab,
            backgroundColor: onFeed ? AppTheme.feedBackground : null,
            selectedItemColor: onFeed ? Colors.white : null,
            unselectedItemColor: onFeed ? Colors.white54 : null,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dynamic_feed_outlined),
                activeIcon: const Icon(Icons.dynamic_feed_rounded),
                label: l10n.navFeed,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_outlined),
                activeIcon: const Icon(Icons.explore_rounded),
                label: l10n.navExplore,
              ),
              BottomNavigationBarItem(
                icon: const _CreateIcon(),
                label: l10n.navCreate,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_outlined),
                activeIcon: const Icon(Icons.notifications_rounded),
                label: l10n.navInbox,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline_rounded),
                activeIcon: const Icon(Icons.person_rounded),
                label: l10n.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Calls [onChanged] whenever routes are pushed, popped or replaced.
class _StackObserver extends NavigatorObserver {
  _StackObserver(this.onChanged);

  final VoidCallback onChanged;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChanged();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      onChanged();
}

/// Flat "+" tile in the brand colour, on the feed and everywhere else.
class _CreateIcon extends StatelessWidget {
  const _CreateIcon();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: AppTheme.brand,
    ),
    child: const Icon(Icons.add_rounded, size: 22, color: AppTheme.ink),
  );
}

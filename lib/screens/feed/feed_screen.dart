import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/feedback.dart';
import '../../models/creation.dart';
import '../../providers/session_provider.dart';
import '../../services/creation_service.dart';
import '../../services/demo_seed.dart';
import '../../widgets/preference_buttons.dart';
import '../../widgets/state_views.dart';
import '../home/home_shell.dart';
import 'feed_item.dart';

/// TikTok-style full-screen vertical feed with "Trending | Latest" tabs.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppTheme.feedBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: l10n.menu,
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => HomeShell.of(context)?.openDrawer(),
        ),
        centerTitle: true,
        titleSpacing: 0,
        // Fixed (non-scrollable) tabs share the space between the two
        // buttons, so both stay fully tappable on narrow phones.
        title: TabBar(
          controller: _tabs,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: [
            Tab(text: l10n.feedTrending),
            Tab(text: l10n.feedLatest),
          ],
        ),
        actions: const [ThemeToggleButton(color: Colors.white)],
      ),
      // Horizontal swipes belong to the creations (games…), so tabs are
      // switched by tapping only.
      body: TabBarView(
        controller: _tabs,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _FeedPager(sort: FeedSort.trending),
          _FeedPager(sort: FeedSort.latest),
        ],
      ),
    );
  }
}

class _FeedPager extends StatefulWidget {
  const _FeedPager({required this.sort});

  final FeedSort sort;

  @override
  State<_FeedPager> createState() => _FeedPagerState();
}

class _FeedPagerState extends State<_FeedPager> {
  final _pageController = PageController();
  late final CreationService _service = context.read<CreationService>();
  late Future<List<Creation>> _future;
  final _viewed = <String>{};
  int _current = 0;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Creation>> _load() async {
    final items = await _service.fetchFeed(widget.sort);
    if (items.isNotEmpty) _markViewed(items.first);
    return items;
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() {
      _future = future;
      _current = 0;
    });
    await future;
    if (_pageController.hasClients) _pageController.jumpToPage(0);
  }

  void _markViewed(Creation creation) {
    if (_viewed.add(creation.id)) _service.registerView(creation.id);
  }

  Future<void> _seed() async {
    final l10n = context.l10n;
    final user = context.read<SessionProvider>().profile;
    if (user == null) return;
    setState(() => _seeding = true);
    try {
      await DemoSeed(_service).run(user);
      if (!mounted) return;
      showAppSnack(context, l10n.seedDone);
      await _refresh();
    } catch (e) {
      if (mounted) showAppSnack(context, describeError(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<List<Creation>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return LoadingView(onDark: true, message: l10n.loading);
        }
        if (snap.hasError) {
          return ErrorView(
            onDark: true,
            message: describeError(l10n, snap.error!),
            onRetry: _refresh,
          );
        }
        final items = snap.data!;
        if (items.isEmpty) {
          return EmptyView(
            onDark: true,
            icon: Icons.account_tree_outlined,
            title: l10n.feedEmptyTitle,
            message: l10n.feedEmptyMessage,
            // The feed is dark in both themes: keep the disabled state visible.
            action: FilledButton(
              style: FilledButton.styleFrom(
                disabledBackgroundColor: Colors.white24,
              ),
              onPressed: _seeding ? null : _seed,
              child: _seeding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.drawerSeedDemo),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          // Already includes the app bar (body extends behind it).
          edgeOffset: MediaQuery.paddingOf(context).top,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              _markViewed(items[i]);
            },
            itemBuilder: (context, i) => FeedItem(
              creation: items[i],
              active: i == _current,
              heroTag: 'feed-${widget.sort.name}-${items[i].id}',
            ),
          ),
        );
      },
    );
  }
}

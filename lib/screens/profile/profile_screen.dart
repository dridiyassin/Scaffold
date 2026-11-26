import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/gamification.dart';
import '../../core/l10n_ext.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/feedback.dart';
import '../../models/app_user.dart';
import '../../models/creation.dart';
import '../../providers/session_provider.dart';
import '../../services/creation_service.dart';
import '../../services/user_service.dart';
import '../../widgets/creation_card.dart';
import '../../widgets/preference_buttons.dart';
import '../../widgets/state_views.dart';
import '../../widgets/user_avatar.dart';
import '../home/home_shell.dart';

/// Creator profile: points & level, stats, and two tabs:
/// * **Originals** – creations that start a new tree;
/// * **Evolutions** – branches, each showing which creation it is based on.
///
/// `userId == null` shows the signed-in user (profile tab).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userId});

  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _uid;
  Stream<AppUser?>? _user;
  Stream<List<Creation>>? _creations;

  @override
  void initState() {
    super.initState();
    _uid = widget.userId ?? context.read<SessionProvider>().uid;
    if (_uid != null) {
      _user = context.read<UserService>().watch(_uid!);
      _creations = context.read<CreationService>().byAuthor(_uid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMe = _uid != null && _uid == context.read<SessionProvider>().uid;
    final canPop = Navigator.of(context).canPop();

    PreferredSizeWidget appBar(String title) => AppBar(
      // Detected per text so "@handle" keeps its "@" in front in Arabic.
      title: Text(title, textDirection: contentDirection(title)),
      leading: canPop
          ? null
          : IconButton(
              tooltip: l10n.menu,
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => HomeShell.of(context)?.openDrawer(),
            ),
      actions: [
        const ThemeToggleButton(),
        if (isMe)
          IconButton(
            tooltip: l10n.navSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.settings),
          ),
      ],
    );

    if (_uid == null) {
      return Scaffold(
        appBar: appBar(l10n.navProfile),
        body: EmptyView(
          icon: Icons.person_off_rounded,
          title: l10n.userNotFound,
        ),
      );
    }

    return StreamBuilder<AppUser?>(
      stream: _user,
      builder: (context, userSnap) {
        final user = userSnap.data;
        final Widget body;
        if (userSnap.hasError) {
          body = ErrorView(message: describeError(l10n, userSnap.error!));
        } else if (user == null) {
          body = userSnap.connectionState == ConnectionState.waiting
              ? const LoadingView()
              : EmptyView(
                  icon: Icons.person_off_rounded,
                  title: l10n.userNotFound,
                );
        } else {
          body = StreamBuilder<List<Creation>>(
            stream: _creations,
            builder: (context, snap) => _ProfileBody(
              user: user,
              isMe: isMe,
              creations: snap.data,
              error: snap.error,
            ),
          );
        }
        return Scaffold(
          appBar: appBar(user == null ? l10n.navProfile : '@${user.username}'),
          body: body,
        );
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.isMe,
    required this.creations,
    required this.error,
  });

  final AppUser user;
  final bool isMe;
  final List<Creation>? creations;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = creations ?? const <Creation>[];
    final originals = all.where((c) => c.isOriginal).toList();
    final evolutions = all.where((c) => !c.isOriginal).toList();

    Widget tabBody(List<Creation> items, String key, String emptyText) {
      if (error != null) {
        return ErrorView(message: describeError(l10n, error!));
      }
      if (creations == null) return const LoadingView();
      return _CreationTab(
        storageKey: key,
        items: items,
        heroPrefix: 'profile-${user.uid}-$key',
        emptyText: emptyText,
      );
    }

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: _ProfileHeader(user: user, isMe: isMe, creations: all),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeader(
                TabBar(
                  tabs: [
                    Tab(text: l10n.profileOriginals(originals.length)),
                    Tab(text: l10n.profileEvolutions(evolutions.length)),
                  ],
                ),
                Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            tabBody(originals, 'originals', l10n.profileNoOriginals),
            tabBody(evolutions, 'evolutions', l10n.profileNoEvolutions),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.isMe,
    required this.creations,
  });

  final AppUser user;
  final bool isMe;
  final List<Creation> creations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final descendants = creations.fold<int>(
      0,
      (s, c) => s + c.descendantsCount,
    );
    final likes = creations.fold<int>(0, (s, c) => s + c.likesCount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'avatar-${user.uid}',
                child: UserAvatar(
                  name: user.displayName,
                  photoUrl: user.photoUrl,
                  radius: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName, style: text.titleLarge),
                    if (user.bio.isNotEmpty)
                      Text(
                        user.bio,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (isMe)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.editProfile),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(l10n.actionEditProfile),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PointsCard(points: user.points),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(value: creations.length, label: l10n.statGenerations),
              _StatTile(value: descendants, label: l10n.statDescendants),
              _StatTile(value: likes, label: l10n.statLikes),
            ],
          ),
        ],
      ),
    );
  }
}

/// Points set large in mono, the level as plain text and a thin progress
/// line to the next level: the one place on the profile with the accent.
class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final level = CreatorLevel.forPoints(points);
    final next = level.next;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Counts up from 0 when the profile opens; shrinks to fit on
                // narrow phones and long translations.
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: points),
                      duration: const Duration(milliseconds: 800),
                      curve: AppTheme.ease,
                      builder: (context, value, _) => Text(
                        l10n.pointsValue(value),
                        style: AppTheme.figures(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  level.label(l10n),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  tooltip: l10n.pointsHowTitle,
                  color: scheme.onSurfaceVariant,
                  icon: const Icon(Icons.info_outline_rounded, size: 20),
                  onPressed: () => _showRules(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: _LevelProgressBar(progress: level.progress(points)),
            ),
            const SizedBox(height: 8),
            Text(
              next == null
                  ? l10n.levelMax
                  : l10n.pointsToNextLevel(
                      next.minPoints - points,
                      next.label(l10n),
                    ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _showRules(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      // Sized to its content (and scrollable on very small screens) instead
      // of the default half-screen cap, which overflowed on small phones.
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pointsHowTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _rule(
                Icons.publish_outlined,
                l10n.pointsRulePublish(PointsRules.publish),
              ),
              _rule(
                Icons.favorite_border_rounded,
                l10n.pointsRuleLike(PointsRules.likeReceived),
              ),
              _rule(
                Icons.call_split_rounded,
                l10n.pointsRuleEvolution(PointsRules.directEvolution),
              ),
              _rule(
                Icons.account_tree_outlined,
                l10n.pointsRuleDescendant(PointsRules.ancestorEvolution),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rule(IconData icon, String text) => ListTile(
    contentPadding: EdgeInsets.zero,
    minLeadingWidth: 20,
    leading: Icon(icon, size: 20),
    title: Text(text),
  );
}

/// AnimatedContainer-based bar that grows to [progress] (0..1).
class _LevelProgressBar extends StatefulWidget {
  const _LevelProgressBar({required this.progress});

  final double progress;

  @override
  State<_LevelProgressBar> createState() => _LevelProgressBarState();
}

class _LevelProgressBarState extends State<_LevelProgressBar> {
  double _shown = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = widget.progress);
    });
  }

  @override
  void didUpdateWidget(_LevelProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _shown = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Fills from the start edge, so from the right in Arabic.
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: 4,
        width: constraints.maxWidth,
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(2),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: AppTheme.ease,
          width: constraints.maxWidth * _shown,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            compactNumber(context, value),
            style: AppTheme.figures(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }
}

class _CreationTab extends StatelessWidget {
  const _CreationTab({
    required this.storageKey,
    required this.items,
    required this.heroPrefix,
    required this.emptyText,
  });

  final String storageKey;
  final List<Creation> items;
  final String heroPrefix;
  final String emptyText;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => CustomScrollView(
      key: PageStorageKey(storageKey),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              icon: Icons.account_tree_outlined,
              title: emptyText,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, i) =>
                  CreationCard(creation: items[i], heroPrefix: heroPrefix),
            ),
          ),
      ],
    ),
  );
}

class _TabBarHeader extends SliverPersistentHeaderDelegate {
  _TabBarHeader(this.tabBar, this.background);

  final TabBar tabBar;
  final Color background;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => ColoredBox(color: background, child: tabBar);

  @override
  bool shouldRebuild(_TabBarHeader oldDelegate) =>
      oldDelegate.tabBar != tabBar || oldDelegate.background != background;
}

import 'package:material_ui/material_ui.dart';

import '../../core/l10n_ext.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_shell.dart';

/// Features planned for Part 2 of the project.
enum Part2Feature {
  editor,
  tree,
  explore,
  inbox,
  leaderboard,
  editProfile,
  premium;

  IconData get icon => switch (this) {
    Part2Feature.editor => Icons.code_rounded,
    Part2Feature.tree => Icons.account_tree_outlined,
    Part2Feature.explore => Icons.explore_outlined,
    Part2Feature.inbox => Icons.notifications_outlined,
    Part2Feature.leaderboard => Icons.emoji_events_outlined,
    Part2Feature.editProfile => Icons.edit_outlined,
    Part2Feature.premium => Icons.workspace_premium_outlined,
  };

  String title(AppLocalizations l) => switch (this) {
    Part2Feature.editor => l.featureEditor,
    Part2Feature.tree => l.featureTree,
    Part2Feature.explore => l.navExplore,
    Part2Feature.inbox => l.navInbox,
    Part2Feature.leaderboard => l.navLeaderboard,
    Part2Feature.editProfile => l.actionEditProfile,
    Part2Feature.premium => l.featurePremium,
  };
}

/// Placeholder for a screen that will be built in Part 2.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.feature,
    this.isTabRoot = false,
  });

  final Part2Feature feature;

  /// Root of a bottom-navigation tab: shows the drawer button.
  final bool isTabRoot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(feature.title(l10n)),
        leading: isTabRoot
            ? IconButton(
                tooltip: l10n.menu,
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => HomeShell.of(context)?.openDrawer(),
              )
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(feature.icon, size: 40, color: scheme.outline),
              const SizedBox(height: 16),
              Text(feature.title(l10n), style: text.titleMedium),
              const SizedBox(height: 8),
              Text(
                l10n.comingSoonMessage,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../core/l10n_ext.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/feedback.dart';
import '../providers/locale_provider.dart';
import '../providers/session_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/creation_service.dart';
import '../services/demo_seed.dart';
import 'user_avatar.dart';

/// Side menu of the home shell.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  final int currentTab;
  final ValueChanged<int> onSelectTab;

  // Same order as the bottom navigation bar.
  static const feedTab = 0;
  static const exploreTab = 1;
  static const inboxTab = 3;
  static const profileTab = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = context.watch<SessionProvider>();
    final user = session.profile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void goTab(int index) {
      Navigator.of(context).pop();
      onSelectTab(index);
    }

    return Drawer(
      child: Column(
        children: [
          // Plain header on the drawer's own surface: who is signed in and
          // their points, no coloured banner.
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  UserAvatar(
                    name: user?.displayName ?? '',
                    photoUrl: user?.photoUrl,
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? '…',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          session.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.pointsValue(user?.points ?? 0),
                    style: AppTheme.figures(
                      fontSize: 13,
                      color: AppTheme.accentText(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _item(
                  context,
                  Icons.dynamic_feed_outlined,
                  l10n.navFeed,
                  selected: currentTab == feedTab,
                  onTap: () => goTab(feedTab),
                ),
                _item(
                  context,
                  Icons.explore_outlined,
                  l10n.navExplore,
                  selected: currentTab == exploreTab,
                  onTap: () => goTab(exploreTab),
                ),
                _item(
                  context,
                  Icons.notifications_outlined,
                  l10n.navInbox,
                  selected: currentTab == inboxTab,
                  onTap: () => goTab(inboxTab),
                ),
                _item(
                  context,
                  Icons.person_outline_rounded,
                  l10n.navProfile,
                  selected: currentTab == profileTab,
                  onTap: () => goTab(profileTab),
                ),
                _item(
                  context,
                  Icons.emoji_events_outlined,
                  l10n.navLeaderboard,
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..pushNamed(AppRoutes.leaderboard);
                  },
                ),
                const Divider(height: 16),
                _item(
                  context,
                  Icons.dark_mode_outlined,
                  l10n.settingsDarkMode,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) => context.read<ThemeProvider>().toggle(
                      Theme.of(context).brightness,
                    ),
                  ),
                  onTap: () => context.read<ThemeProvider>().toggle(
                    Theme.of(context).brightness,
                  ),
                ),
                _item(
                  context,
                  Icons.translate_rounded,
                  l10n.settingsLanguage,
                  trailing: Text(
                    LocaleProvider.nativeName(
                      Localizations.localeOf(context).languageCode,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () => _pickLanguage(context),
                ),
                _item(
                  context,
                  Icons.settings_outlined,
                  l10n.navSettings,
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..pushNamed(AppRoutes.settings);
                  },
                ),
                const Divider(height: 16),
                _item(
                  context,
                  Icons.playlist_add_rounded,
                  l10n.drawerSeedDemo,
                  onTap: () => _seedDemo(context),
                ),
                _item(
                  context,
                  Icons.logout_rounded,
                  l10n.actionSignOut,
                  onTap: () => confirmSignOut(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title, {
    bool selected = false,
    Widget? trailing,
    required VoidCallback onTap,
  }) => ListTile(
    // Dense rows, icons in one 20px column, selection as a surface step.
    dense: true,
    visualDensity: VisualDensity.compact,
    minLeadingWidth: 20,
    leading: Icon(icon, size: 20),
    title: Text(title, style: const TextStyle(fontSize: 15)),
    trailing: trailing,
    selected: selected,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    onTap: onTap,
  );

  Future<void> _pickLanguage(BuildContext context) async {
    final provider = context.read<LocaleProvider>();
    final current = Localizations.localeOf(context).languageCode;
    final code = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in LocaleProvider.supported)
              ListTile(
                title: Text(LocaleProvider.nativeName(locale.languageCode)),
                trailing: locale.languageCode == current
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () =>
                    Navigator.of(sheetContext).pop(locale.languageCode),
              ),
          ],
        ),
      ),
    );
    if (code != null) await provider.setLocale(Locale(code));
  }

  Future<void> _seedDemo(BuildContext context) async {
    final l10n = context.l10n;
    final user = context.read<SessionProvider>().profile;
    final service = context.read<CreationService>();
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    if (user == null) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.seedInProgress)));
    try {
      await DemoSeed(service).run(user);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.seedDone)));
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(describeError(l10n, e))));
    }
  }
}

/// Asks for confirmation, signs out and returns to the login screen.
Future<void> confirmSignOut(BuildContext context) async {
  final l10n = context.l10n;
  final navigator = Navigator.of(context, rootNavigator: true);
  final auth = context.read<AuthService>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.logout_rounded, size: 24),
      title: Text(l10n.signOutTitle),
      content: Text(l10n.signOutMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.actionSignOut),
        ),
      ],
    ),
  );
  if (ok != true) return;
  await auth.signOut();
  navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
}

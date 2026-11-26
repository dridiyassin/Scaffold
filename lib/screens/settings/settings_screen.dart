import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/locale_provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_drawer.dart';

/// Theme (persisted), language (persisted, RTL for Arabic) and account.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final session = context.watch<SessionProvider>();
    final selectedCode = localeProvider.locale?.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _Section(l10n.settingsAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_outlined),
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_outlined),
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {theme.mode},
              onSelectionChanged: (s) => theme.setMode(s.first),
            ),
          ),
          _Section(l10n.settingsLanguage),
          _LanguageTile(
            title: l10n.languageSystem,
            selected: selectedCode == null,
            onTap: () => localeProvider.setLocale(null),
          ),
          for (final locale in LocaleProvider.supported)
            _LanguageTile(
              title: LocaleProvider.nativeName(locale.languageCode),
              selected: selectedCode == locale.languageCode,
              onTap: () => localeProvider.setLocale(locale),
            ),
          _Section(l10n.settingsAccount),
          ListTile(
            title: Text(l10n.fieldEmail),
            subtitle: Text(session.email ?? '—'),
          ),
          ListTile(
            title: Text(
              l10n.actionSignOut,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => confirmSignOut(context),
          ),
          const Divider(height: 32),
          AboutListTile(
            applicationName: l10n.appName,
            applicationVersion: '1.0.0 (Part 1)',
            applicationLegalese: l10n.appTagline,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
    child: Text(title, style: Theme.of(context).textTheme.bodySmall),
  );
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    trailing: AnimatedOpacity(
      opacity: selected ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: Icon(
        Icons.check_rounded,
        size: 20,
        color: AppTheme.accentText(context),
      ),
    ),
    // Selection shows as the check, not a tinted row.
    selectedTileColor: Colors.transparent,
    selected: selected,
    onTap: onTap,
  );
}

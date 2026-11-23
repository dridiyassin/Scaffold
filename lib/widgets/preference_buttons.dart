import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../core/l10n_ext.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

/// Light/dark toggle with an animated icon. The choice is persisted by
/// [ThemeProvider].
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      color: color,
      tooltip: context.l10n.themeToggle,
      onPressed: () =>
          context.read<ThemeProvider>().toggle(Theme.of(context).brightness),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween(begin: 0.6, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(isDark),
        ),
      ),
    );
  }
}

/// Language menu (English / Français / العربية).
class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    return PopupMenuButton<String>(
      tooltip: context.l10n.settingsLanguage,
      icon: Icon(Icons.translate_rounded, color: color),
      initialValue: current,
      onSelected: (code) =>
          context.read<LocaleProvider>().setLocale(Locale(code)),
      itemBuilder: (_) => [
        for (final locale in LocaleProvider.supported)
          CheckedPopupMenuItem(
            value: locale.languageCode,
            checked: locale.languageCode == current,
            child: Text(LocaleProvider.nativeName(locale.languageCode)),
          ),
      ],
    );
  }
}

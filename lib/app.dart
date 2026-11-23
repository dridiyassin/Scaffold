import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'core/l10n_ext.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/common/firebase_setup_screen.dart';

class ScaffoldApp extends StatelessWidget {
  const ScaffoldApp({super.key, required this.firebaseError});

  /// Non-null when Firebase failed to initialise.
  final Object? firebaseError;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().mode;
    final locale = context.watch<LocaleProvider>().locale;
    final firebaseReady = firebaseError == null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // null = follow the device language.
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      // material_ui ships its own Material/Cupertino/Widgets delegates (the
      // Widgets one switches to right-to-left layout for Arabic).
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      initialRoute: AppRoutes.splash,
      onGenerateRoute: firebaseReady
          ? AppRouter.onGenerateRoute
          : (_) => MaterialPageRoute<void>(
              builder: (_) => FirebaseSetupScreen(error: firebaseError),
            ),
    );
  }
}

import 'package:material_ui/material_ui.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/common/coming_soon_screen.dart';
import '../../screens/common/route_error_screen.dart';
import '../../screens/creation/creation_detail_screen.dart';
import '../../screens/home/home_shell.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/splash/splash_screen.dart';
import 'app_routes.dart';

/// Central `onGenerateRoute`: maps route names + typed arguments to screens.
///
/// Used by the root [MaterialApp] *and* by the nested navigators of each
/// bottom-navigation tab (see `HomeShell`).
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen(), settings);
      case AppRoutes.login:
        return _fade(const LoginScreen(), settings);
      case AppRoutes.register:
        return _page(const RegisterScreen(), settings);
      case AppRoutes.forgotPassword:
        // The login screen passes the e-mail already typed (String argument).
        return _page(
          ForgotPasswordScreen(initialEmail: args is String ? args : null),
          settings,
        );
      case AppRoutes.home:
        return _fade(const HomeShell(), settings);
      case AppRoutes.settings:
        return _page(const SettingsScreen(), settings);
      case AppRoutes.creationDetail:
        if (args is! CreationDetailArgs) return _error(settings);
        return _page(CreationDetailScreen(args: args), settings);
      case AppRoutes.userProfile:
        if (args is! UserProfileArgs) return _error(settings);
        return _page(ProfileScreen(userId: args.userId), settings);

      // ---- Part 2 placeholders ----
      case AppRoutes.editor:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.editor),
          settings,
        );
      case AppRoutes.tree:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.tree),
          settings,
        );
      case AppRoutes.explore:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.explore),
          settings,
        );
      case AppRoutes.notifications:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.inbox),
          settings,
        );
      case AppRoutes.leaderboard:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.leaderboard),
          settings,
        );
      case AppRoutes.editProfile:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.editProfile),
          settings,
        );
      case AppRoutes.premium:
        return _page(
          const ComingSoonScreen(feature: Part2Feature.premium),
          settings,
        );
    }
    return _error(settings);
  }

  static Route<dynamic> _page(Widget child, RouteSettings settings) =>
      MaterialPageRoute<dynamic>(builder: (_) => child, settings: settings);

  static Route<dynamic> _fade(Widget child, RouteSettings settings) =>
      PageRouteBuilder<dynamic>(
        settings: settings,
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => child,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      );

  static Route<dynamic> _error(RouteSettings settings) =>
      _page(RouteErrorScreen(routeName: settings.name), settings);
}

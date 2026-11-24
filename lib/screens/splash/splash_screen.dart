import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/session_provider.dart';
import '../../widgets/logo_mark.dart';

/// The app icon and name fade in while the auth state is restored, then routes to
/// home (signed in) or login (signed out).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    _route();
  }

  Future<void> _route() async {
    final session = context.read<SessionProvider>();
    await Future.wait([
      session.ready,
      Future<void>.delayed(const Duration(milliseconds: 1500)),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      session.uid != null ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    // One short fade and rise, then nothing moves but the progress ring.
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          curve: AppTheme.ease,
          child: AnimatedSlide(
            offset: _visible ? Offset.zero : const Offset(0, 0.1),
            duration: const Duration(milliseconds: 400),
            curve: AppTheme.ease,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Hero(tag: 'app-logo', child: AppIcon(size: 88)),
                const SizedBox(height: 20),
                Text(
                  'Scaffold',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                // Narrow enough that the line breaks into two even halves.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      l10n.appTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

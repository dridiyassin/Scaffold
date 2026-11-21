import 'package:material_ui/material_ui.dart';

import '../../core/l10n_ext.dart';
import '../../widgets/preference_buttons.dart';

/// Shown instead of the app when Firebase could not be initialised
/// (usually because `flutterfire configure` has not been run yet).
class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key, required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.firebaseSetupTitle),
        actions: const [LanguageMenuButton(), ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 72,
            color: scheme.error,
          ),
          const SizedBox(height: 16),
          Text(l10n.firebaseSetupMessage, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SelectableText(
                'dart pub global activate flutterfire_cli\n'
                'flutterfire configure',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (error != null)
            Text('$error', style: TextStyle(color: scheme.error, fontSize: 12)),
        ],
      ),
    );
  }
}

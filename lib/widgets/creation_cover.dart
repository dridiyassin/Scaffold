import 'package:material_ui/material_ui.dart';

import '../core/category_ui.dart';
import '../core/theme/app_theme.dart';
import '../models/creation.dart';

/// Stand-in for a creation before it runs: a neutral tile with its category
/// icon (thumbnail), or the dark feed ground with its title (full page).
class CreationCover extends StatelessWidget {
  const CreationCover({
    super.key,
    required this.creation,
    this.compact = false,
    this.borderRadius,
  });

  final Creation creation;

  /// Small thumbnail (icon only) instead of the full-page cover.
  final bool compact;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final category = creation.category;
    if (compact) {
      final scheme = Theme.of(context).colorScheme;
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: borderRadius,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Center(
          child: Icon(category.icon, color: scheme.onSurfaceVariant, size: 24),
        ),
      );
    }
    return ColoredBox(
      color: AppTheme.feedBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, color: Colors.white38, size: 40),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                creation.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

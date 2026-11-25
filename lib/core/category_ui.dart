import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../models/creation.dart';

/// Icon and label of each [CreationCategory]. Categories carry no colour of
/// their own: the colour belongs to the creations.
extension CreationCategoryUi on CreationCategory {
  IconData get icon => switch (this) {
    CreationCategory.game => Icons.sports_esports_outlined,
    CreationCategory.website => Icons.language_outlined,
    CreationCategory.tool => Icons.handyman_outlined,
    CreationCategory.simulation => Icons.science_outlined,
    CreationCategory.app => Icons.apps_outlined,
    CreationCategory.art => Icons.palette_outlined,
  };

  String label(AppLocalizations l) => switch (this) {
    CreationCategory.game => l.categoryGame,
    CreationCategory.website => l.categoryWebsite,
    CreationCategory.tool => l.categoryTool,
    CreationCategory.simulation => l.categorySimulation,
    CreationCategory.app => l.categoryApp,
    CreationCategory.art => l.categoryArt,
  };
}

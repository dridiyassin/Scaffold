import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

extension L10nX on BuildContext {
  /// Shortcut for `AppLocalizations.of(context)`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

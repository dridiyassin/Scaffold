import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Selected app language (null = follow the device), persisted.
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._prefs) {
    final code = _prefs.getString(_key);
    if (code != null && supported.any((l) => l.languageCode == code)) {
      _locale = Locale(code);
    }
  }

  static const _key = 'locale';
  static const supported = [Locale('en'), Locale('fr'), Locale('ar')];

  final SharedPreferences _prefs;
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    if (locale == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, locale.languageCode);
    }
  }

  /// Native name of a language, shown in pickers.
  static String nativeName(String languageCode) => switch (languageCode) {
    'fr' => 'Français',
    'ar' => 'العربية',
    _ => 'English',
  };
}

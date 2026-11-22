import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light / dark / system theme, persisted across app restarts.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._prefs) : _mode = _decode(_prefs.getString(_key));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_key, mode.name);
  }

  /// Flips between light and dark based on what is currently displayed.
  Future<void> toggle(Brightness current) =>
      setMode(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);

  static ThemeMode _decode(String? value) => ThemeMode.values.firstWhere(
    (m) => m.name == value,
    orElse: () => ThemeMode.system,
  );
}

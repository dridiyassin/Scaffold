import 'package:material_ui/material_ui.dart';

/// Light and dark themes for Scaffold: one graphite neutral ramp, one
/// saturated brand colour, IBM Plex type.
abstract final class AppTheme {
  /// The brand colour: safety orange, the colour of scaffolding and building
  /// sites, the same as the app icon. Used as a fill (primary buttons, the
  /// Create tab, progress, switches) with [ink] on top, which keeps 6:1.
  static const brand = Color(0xFFFF6A00);

  /// Ink drawn on [brand], and the tile of the app icon.
  static const ink = Color(0xFF121213);

  /// The brand hue, darker, for text and thin lines on light surfaces, where
  /// [brand] itself would fall under 4.5:1.
  static const brandText = Color(0xFFC84A00);

  /// Orange for text and icons: [brandText] on light screens, [brand] on dark.
  static Color accentText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? brandText : brand;

  /// Heart colour for likes.
  static const like = Color(0xFFF2445E);

  /// Ground of the full-screen feed, the same in both themes.
  static const feedBackground = Color(0xFF0F0F10);

  static const sans = 'IBM Plex Sans';
  static const sansArabic = 'IBM Plex Sans Arabic';
  static const mono = 'IBM Plex Mono';

  /// The one easing curve used for every transition in the app.
  static const ease = Cubic(0.22, 1, 0.36, 1);

  /// Counts, points and handles: the interface face with tabular figures, so
  /// a changing number does not shift its neighbours.
  static TextStyle figures({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) => TextStyle(
    fontFamily: sans,
    fontFamilyFallback: const [sansArabic],
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: 0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// Source code of a creation, and nothing else.
  static TextStyle code({double fontSize = 12.5, Color? color}) => TextStyle(
    fontFamily: mono,
    fontFamilyFallback: const [sansArabic],
    fontSize: fontSize,
    color: color,
    letterSpacing: 0,
  );

  static ThemeData light() => _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: brand,
      onPrimary: ink,
      primaryContainer: Color(0xFFFFE7D6),
      onPrimaryContainer: Color(0xFF7A2E00),
      secondary: Color(0xFF525252),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFECECED),
      onSecondaryContainer: Color(0xFF171717),
      tertiary: Color(0xFF525252),
      onTertiary: Color(0xFFFFFFFF),
      error: Color(0xFFDC2626),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFDE8E8),
      onErrorContainer: Color(0xFF8A1313),
      surface: Color(0xFFFAFAFA),
      onSurface: Color(0xFF171717),
      onSurfaceVariant: Color(0xFF525252),
      outline: Color(0xFF737373),
      outlineVariant: Color(0xFFE5E5E6),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFFFFFF),
      surfaceContainer: Color(0xFFF4F4F5),
      surfaceContainerHigh: Color(0xFFF0F0F1),
      surfaceContainerHighest: Color(0xFFEAEAEB),
      surfaceTint: Color(0x00000000),
      inverseSurface: Color(0xFF171717),
      onInverseSurface: Color(0xFFF4F4F5),
      inversePrimary: brand,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
    ),
  );

  static ThemeData dark() => _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: brand,
      onPrimary: ink,
      primaryContainer: Color(0xFF40200A),
      onPrimaryContainer: Color(0xFFFFD3B3),
      secondary: Color(0xFFA1A1A6),
      onSecondary: Color(0xFF141415),
      secondaryContainer: Color(0xFF2A2A2D),
      onSecondaryContainer: Color(0xFFEDEDED),
      tertiary: Color(0xFFA1A1A6),
      onTertiary: Color(0xFF141415),
      error: Color(0xFFE5484D),
      onError: Color(0xFF141415),
      errorContainer: Color(0xFF3B1517),
      onErrorContainer: Color(0xFFFFC9C9),
      surface: Color(0xFF141415),
      onSurface: Color(0xFFEDEDED),
      onSurfaceVariant: Color(0xFFA1A1A6),
      outline: Color(0xFF85858B),
      outlineVariant: Color(0xFF2A2A2C),
      surfaceContainerLowest: Color(0xFF0F0F10),
      surfaceContainerLow: Color(0xFF19191B),
      surfaceContainer: Color(0xFF1E1E20),
      surfaceContainerHigh: Color(0xFF232325),
      surfaceContainerHighest: Color(0xFF29292B),
      surfaceTint: Color(0x00000000),
      inverseSurface: Color(0xFFEDEDED),
      onInverseSurface: Color(0xFF141415),
      inversePrimary: brandText,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final isLight = scheme.brightness == Brightness.light;
    // Text and thin lines in the brand hue stay readable on white.
    final accentText = isLight ? brandText : brand;
    const control = BorderRadius.all(Radius.circular(10));
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: control,
          borderSide: BorderSide(color: color, width: width),
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: sans,
      // Plex Sans has no Arabic glyphs: Arabic text uses its sister family.
      fontFamilyFallback: const [sansArabic],
    );
    final text = base.textTheme;
    // Hierarchy from size and colour; weights stay between 400 and 600.
    final textTheme = text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w500),
      bodySmall: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
    );
    const buttonText = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: scheme.onSurface,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentText,
        selectionHandleColor: brand,
        selectionColor: brand.withValues(alpha: 0.28),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? Colors.white : scheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border(scheme.outlineVariant),
        enabledBorder: border(scheme.outlineVariant),
        focusedBorder: border(accentText, 1.5),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 1.5),
      ),
      // Primary buttons carry the brand colour, with ink on top.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: brand,
          foregroundColor: ink,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(borderRadius: control),
          textStyle: buttonText.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: BorderSide(color: scheme.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: control),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentText,
          shape: const RoundedRectangleBorder(borderRadius: control),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        selectedColor: scheme.onSurface,
        selectedTileColor: scheme.secondaryContainer,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: brand,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: scheme.outlineVariant,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.onSurface,
        unselectedItemColor: scheme.outline,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: control,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: brand,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        dragHandleColor: scheme.outline,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: scheme.surface),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontFamily: sans,
          fontFamilyFallback: const [sansArabic],
          fontSize: 14,
          color: scheme.onInverseSurface,
        ),
        actionTextColor: isLight ? brand : brandText,
        shape: const RoundedRectangleBorder(borderRadius: control),
      ),
    );
  }
}

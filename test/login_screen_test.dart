import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold/l10n/app_localizations.dart';
import 'package:scaffold/providers/locale_provider.dart';
import 'package:scaffold/providers/theme_provider.dart';
import 'package:scaffold/screens/auth/login_screen.dart';
import 'package:scaffold/screens/auth/register_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps [screen] the same way app.dart configures MaterialApp
/// (no Firebase needed: services are only read when a form is submitted).
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen,
  Locale locale,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
      ],
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('login shows clear errors for an empty form', (tester) async {
    await pumpScreen(tester, const LoginScreen(), const Locale('en'));

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    expect(find.text('Please enter your e-mail.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
  });

  testWidgets('login rejects a malformed e-mail', (tester) async {
    await pumpScreen(tester, const LoginScreen(), const Locale('en'));

    await tester.enterText(find.byType(TextFormField).first, 'ada@');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    expect(find.text('This e-mail address is not valid.'), findsOneWidget);
  });

  testWidgets('register validates every field and the terms checkbox', (
    tester,
  ) async {
    await pumpScreen(tester, const RegisterScreen(), const Locale('fr'));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'A');
    await tester.enterText(fields.at(1), 'ada@example.com');
    await tester.enterText(fields.at(2), 'abcdefgh');
    await tester.enterText(fields.at(3), 'different1');
    final submit = find.widgetWithText(FilledButton, 'Créer le compte');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pump();

    expect(
      find.text('Le nom doit contenir au moins 2 caractères.'),
      findsOneWidget,
    );
    expect(
      find.text('Utilisez au moins une lettre et un chiffre.'),
      findsOneWidget,
    );
    expect(
      find.text('Les mots de passe ne correspondent pas.'),
      findsOneWidget,
    );
    expect(
      find.text('Vous devez accepter les conditions pour continuer.'),
      findsOneWidget,
    );
  });

  testWidgets('Arabic renders right-to-left with Arabic Material strings', (
    tester,
  ) async {
    await pumpScreen(tester, const LoginScreen(), const Locale('ar'));

    final context = tester.element(find.byType(LoginScreen));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.text('تسجيل الدخول إلى Scaffold'), findsOneWidget);
    // Proves material_ui's localization delegates are wired (not English).
    expect(
      MaterialLocalizations.of(context).cancelButtonLabel,
      isNot('Cancel'),
    );
    expect(tester.takeException(), isNull);
  });
}

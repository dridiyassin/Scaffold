import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/locale_provider.dart';
import 'providers/session_provider.dart';
import 'providers/theme_provider.dart';
import 'services/auth_service.dart';
import 'services/creation_service.dart';
import 'services/user_service.dart';

/// Registers every provider of the app above [child].
///
/// [firestore] and [auth] default to the real Firebase instances; tests pass
/// fakes. When [firebaseReady] is false only theme and language are provided
/// (the app then shows the Firebase setup screen).
class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.prefs,
    required this.child,
    this.firebaseReady = true,
    this.firestore,
    this.auth,
  });

  final SharedPreferences prefs;
  final Widget child;
  final bool firebaseReady;
  final FirebaseFirestore? firestore;
  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
      if (firebaseReady) ...[
        Provider(create: (_) => UserService(firestore: firestore)),
        Provider(create: (_) => CreationService(firestore: firestore)),
        Provider(
          create: (context) =>
              AuthService(context.read<UserService>(), auth: auth),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionProvider(
            context.read<AuthService>(),
            context.read<UserService>(),
          ),
        ),
      ],
    ],
    child: child,
  );
}

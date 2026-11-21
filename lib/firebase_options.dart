// PLACEHOLDER — overwritten by `flutterfire configure`.
//
// Run (once, from the project root):
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Until then the app starts on a "Firebase is not configured" screen.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'DefaultFirebaseOptions have not been configured. '
    'Run `flutterfire configure` to generate lib/firebase_options.dart.',
  );
}

// Browser demo of Scaffold that runs without a Firebase project.
//
// Same app as lib/main.dart, but Firestore and Auth are in-memory fakes
// (data is lost on reload) and creations run in sandboxed iframes.
//
//   flutter build web -t demo/main.dart -o build/web_demo
//   flutter run -d chrome -t demo/main.dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:scaffold/app.dart';
import 'package:scaffold/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'iframe_webview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Expose the widget tree to screen readers and browser automation.
  SemanticsBinding.instance.ensureSemantics();
  WebViewPlatform.instance = IframeWebViewPlatform();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    AppProviders(
      prefs: prefs,
      firestore: FakeFirebaseFirestore(),
      auth: MockFirebaseAuth(),
      child: const ScaffoldApp(firebaseError: null),
    ),
  );
}

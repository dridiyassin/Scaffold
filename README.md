<img src="brand/scaffold-icon.svg" width="88" alt="Scaffold app icon">

# Scaffold

A social platform to **discover, create, share and evolve** small interactive creations
(mini-games, websites, tools, simulations). Creations scroll in a TikTok-style feed;
anyone can *evolve* one, which creates a new branch while the original and its history
are preserved. Over time a creation grows into a tree of variations. Creators earn
points from engagement and from the success of their descendants.

Built with Flutter 3.50 (`material_ui`), Firebase (Auth + Cloud Firestore) and Provider.
Dart package `scaffold`; Android `applicationId` and iOS bundle id `com.dridiyassin.scaffold`.

---

## Project split

### ✅ Part 1: done

| Requirement | Where |
|---|---|
| Cloud Firestore | `lib/services/creation_service.dart`, `user_service.dart`, `firestore.rules` |
| FirebaseAuth: e-mail/password + Google Sign-In | `lib/services/auth_service.dart` |
| Forms + validation (login, register, forgot password) | `lib/screens/auth/*`, `lib/core/utils/validators.dart` |
| FR / EN / AR + in-app switch + RTL | `lib/l10n/*.arb`, `lib/providers/locale_provider.dart` |
| Light/dark theme button, persisted | `lib/providers/theme_provider.dart`, `widgets/preference_buttons.dart` |
| Drawer, BottomNavigationBar, TabBar | `widgets/app_drawer.dart`, `screens/home/home_shell.dart`, feed / detail / profile tabs |
| Animations: Hero, AnimatedContainer, AnimatedOpacity | splash → sign-in logo, feed → detail, like button, profile level bar, lineage nodes, forgot-password |
| State management: Provider | `lib/providers/*`, `main.dart` |
| Named routes, typed arguments, nested navigation | `lib/core/routing/*`, one `Navigator` per bottom tab in `home_shell.dart` |
| Loading / error / empty states, SnackBars | `widgets/state_views.dart`, `core/utils/feedback.dart` |
| Points system + creator levels | `core/gamification.dart`, applied atomically in `CreationService` |

**Screens built (9):** Splash · Login · Register · Forgot password · Home shell ·
Feed (TikTok vertical, *Trending / Latest*) · Creation detail (*Preview / Code / Lineage*) ·
Profile (points, level, *Originals / Branches* with "based on" lineage) · Settings.

The data layer for evolutions is complete: `CreationService.publish(parent: …)` creates a
branch, updates `forksCount` / `descendantsCount` on every ancestor and awards points to the
whole lineage in one batch. **Drawer → "Load demo creations"** publishes a small demo tree
so the feed, lineage and profile can be tried before the editor exists.

### ⏳ Part 2: to do

Each item already has a route and a placeholder screen (`ComingSoonScreen`). Replace the
placeholder in `lib/core/routing/app_router.dart`.

| Feature | Route / entry point | Notes |
|---|---|---|
| **Editor / Evolve** (form + validation, code + live preview) | `AppRoutes.editor`, `EditorArgs(parent:)` | Call `CreationService.publish(...)`. "Create" tab and every "Evolve" button already open it. |
| **Evolution tree** screen | `AppRoutes.tree`, `TreeArgs(rootId, focusId)` | Query `creations` where `rootId == …`. |
| **Explore**: REST API with `dio`/`http`, `FutureBuilder`, `ListView.builder` | Explore tab (`home_shell.dart`) | |
| **Push notifications** (`firebase_messaging`): foreground + background, tap opens the right screen, one notification triggered by an in-app action (e.g. "your creation was evolved") | Inbox tab, `AppRoutes.notifications` | Navigate with `AppRoutes.creationDetail` + `CreationDetailArgs`. |
| **Ads** (`google_mobile_ads`): banner + interstitial, **Google test IDs only** | e.g. banner in Explore, interstitial after publishing | Needs the AdMob test App ID in `AndroidManifest.xml`. |
| **Lottie** animation | e.g. publish success, empty states | |
| Leaderboard, Edit profile | `AppRoutes.leaderboard`, `AppRoutes.editProfile` | Edit profile = another validated form. |
| Bonus: Stripe test payment → Firestore transaction | `AppRoutes.premium` | |
| Bonus: AI code generation | inside the editor | |
| Bonus: offline cache (Hive / sqflite) | | |

---

## Setup

### 1. Tools (already installed on this PC)

Everything lives in `Y:\SDKs` and is on the **user PATH** (open a new terminal to pick it up):

| Tool | Location |
|---|---|
| Flutter 3.50.1 | `Y:\SDKs\flutter` |
| JDK 21 (`JAVA_HOME`) | `Y:\SDKs\jdk-21` |
| Android SDK (`ANDROID_HOME`): API 36, build-tools 36.1, NDK 28.2, emulator | `Y:\SDKs\android` |
| Emulator device `medium_phone` (Android 36 + Google Play) | `%USERPROFILE%\.android\avd` |
| Firebase CLI (`firebase`) and FlutterFire CLI (`flutterfire`) | npm / pub global |

`flutter doctor` is green for Android. (`android/gradle.properties` sets
`kotlin.incremental=false` because the project and the pub cache are on different drives.)

### 2. Firebase (done)
The app is connected to the Firebase project **`scaffold-dridiyassin`**
([console](https://console.firebase.google.com/project/scaffold-dridiyassin/overview)):

| Piece | Where it comes from |
|---|---|
| Android, iOS and web apps | `flutterfire configure` → `lib/firebase_options.dart`, `android/app/google-services.json` |
| Firestore (default database, `europe-west1`) + security rules | `firebase.json` → `firebase deploy --only firestore` |
| Sign-in: e-mail/password and Google | `firebase.json` (`auth.providers`) → `firebase deploy --only auth` |
| Google Sign-In on Android | debug-key SHA-1 and SHA-256 of this PC registered on the Android app |
| Google Sign-In on iOS | client id and URL scheme in `ios/Runner/Info.plist` |

`.firebaserc` makes `scaffold-dridiyassin` the default project, so `firebase deploy` needs no flag.

**Building on another PC:** Google Sign-In on Android only accepts builds signed with a registered
key. Get that PC's debug SHA-1 (`cd android; .\gradlew signingReport`), then:
```
firebase apps:android:sha:create 1:951302454103:android:4b29db2fbb9d1205931c12 <SHA-1>
flutterfire configure --project scaffold-dridiyassin --platforms android,ios,web --android-package-name com.dridiyassin.scaffold --ios-bundle-id com.dridiyassin.scaffold --yes
```
Do the same with the release key before publishing. Google Sign-In is wired for Android and iOS;
on the web, sign in with e-mail.

### 3. Run
Either plug in an Android phone with **USB debugging** enabled, or use the emulator. The
emulator needs hardware virtualization, which is currently **off on this PC**:
1. Reboot into the BIOS/UEFI and enable **Intel Virtualization Technology (VT-x)**.
2. In Windows, *Turn Windows features on or off* → tick **Windows Hypervisor Platform** (needs admin), reboot.
3. `flutter emulators --launch medium_phone`

Then:
```
flutter run
```

### Try it now without Firebase (browser demo)
```
flutter run -d chrome -t demo/main.dart
```
Same app, but Firestore and Auth are in-memory fakes (data resets on reload) and creations run
in sandboxed iframes instead of the phone WebView. Sign up with any e-mail, then tap
**Load demo creations**. To serve a build instead:
`flutter build web --debug -t demo/main.dart -o build/web_demo`, then `node demo/serve.mjs`
and open <http://localhost:8080>. (Debug only: the Firebase test fakes refuse to run in release builds.)

**Screenshots:** `screenshots/` holds 25 screens captured from this demo (EN / FR / AR, light and
dark); `screenshots/00-overview.png` shows them all on one page and
`screenshots/00-before-after.png` compares seven screens before and after the design pass below.

## Design

The interface went through an "unslop" pass (the [unslop](https://heydamir.design/unslop) skill by
Damir Sokolovsky, CC BY 4.0, and [taste-skill](https://github.com/Leonxlnx/taste-skill)) to drop the
generic AI-generated look: no violet gradients, glows, sparkle icons, pills everywhere or
exclamation marks.

- **Direction:** an entertainment feed where every creation can be built on top of, like floors
  on a scaffold. Grey, quiet chrome; one loud brand colour; the rest of the colour comes from the
  creations themselves.
- **Icon** (`brand/`): three stacked layers inside a scaffold frame, with a play button cut out of
  the top layer. `scaffold-icon.svg` (rounded tile), `scaffold-icon-square.svg` (full bleed, for
  stores), `scaffold-mark.svg` (mark only), `scaffold-logo.svg` (tile with the name) and
  `icon-preview.png` (sizes, Android masks, home screen). The launcher icons for Android (legacy,
  adaptive and Android 13 themed), iOS and the web are rendered from the same geometry, and
  `lib/widgets/logo_mark.dart` draws it in the app.
- **Colour** (`lib/core/theme/app_theme.dart`): one graphite neutral ramp for every surface, and
  one saturated brand colour, safety orange `#FF6A00`, the colour of building sites. It fills
  primary buttons, the Create tab, progress, switches and tab indicators, always with ink
  (`#121213`) on top (6:1). On light screens, orange text and thin lines use the same hue darker
  (`#C84A00`) to keep 4.5:1 on white. Likes keep their red heart.
- **Type:** IBM Plex Sans for the interface (counts and points with tabular figures), IBM Plex Sans
  Arabic for Arabic, IBM Plex Mono only for creation source code (weights 400 to 600). The fonts
  are bundled in `assets/fonts` under the SIL Open Font License (`assets/fonts/OFL.txt`).
- **Lineage:** a branch glyph marks every "Branch of …" line, and the Lineage tab draws ancestors
  as one continuous rail.
- **Motion:** one easing curve (`AppTheme.ease`), short fades and colour changes, no bounce. The
  app icon flies from the splash to the sign-in screen (Hero).

### 4. Tests
```
flutter analyze
flutter test
```
22 tests, run without a device or Firebase (in-memory Firestore, mocked Auth, fake WebView):
- `test/creation_service_test.dart`: lineage, descendant counts, points for every ancestor, likes, trending order.
- `test/login_screen_test.dart`: form validation messages, Arabic RTL.
- `test/app_flow_test.dart`: sign-up, demo feed, likes, profile branches, detail lineage,
  settings (dark + Arabic, persisted), and a tour of every screen in EN / FR / AR on a 360×640 phone.

---

## Data model (Firestore)

```
users/{uid}                  displayName, username, email, photoUrl, bio, points, creationsCount
creations/{id}               title, description, code (HTML), category, tags,
                             authorId/Name/Username/PhotoUrl,
                             parentId, parentTitle, parentAuthorId/Name,
                             rootId, ancestorIds[], ancestorAuthorIds[],
                             likesCount, forksCount, descendantsCount, viewsCount, createdAt
creations/{id}/likes/{uid}   createdAt
```

**Points:** publish +5 · like received +2 · direct evolution of your creation +10 ·
each evolution deeper in your tree +3. Levels: Seed → Sprout (50) → Sapling (200) →
Tree (750) → Forest (2500).

## Structure

```
lib/
  core/        theme, routing (routes + typed args), validators, feedback helpers, gamification
  l10n/        app_en.arb, app_fr.arb, app_ar.arb (+ generated code)
  models/      Creation, AppUser
  providers/   ThemeProvider, LocaleProvider, SessionProvider
  services/    AuthService, UserService, CreationService, DemoSeed
  screens/     splash, auth, home, feed, creation, profile, settings, common
  widgets/     drawer, WebView runner, cards, like button, state views…
assets/fonts/  IBM Plex Sans, Sans Arabic and Mono (OFL)
brand/         app icon and logo (SVG) + icon preview
demo/          browser demo entry point (in-memory Firebase, iframe WebView, static server)
screenshots/   captured screens + overview
```

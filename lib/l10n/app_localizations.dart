import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Scaffold'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Play mini-games and tiny apps, then build your own on top'**
  String get appTagline;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @navFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get navFeed;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get navCreate;

  /// No description provided for @navInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get navInbox;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get navLeaderboard;

  /// No description provided for @featureEditor.
  ///
  /// In en, this message translates to:
  /// **'Code editor'**
  String get featureEditor;

  /// No description provided for @featureTree.
  ///
  /// In en, this message translates to:
  /// **'Evolution tree'**
  String get featureTree;

  /// No description provided for @featurePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get featurePremium;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Planned for Part 2 of the project'**
  String get comingSoonMessage;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFound;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Scaffold'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'With your e-mail or your Google account'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each creation you publish starts a new tree'**
  String get registerSubtitle;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get registerSuccess;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll e-mail you a link to choose a new password'**
  String get forgotSubtitle;

  /// No description provided for @forgotSent.
  ///
  /// In en, this message translates to:
  /// **'A reset link was sent to {email}. Check your inbox.'**
  String forgotSent(String email);

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @fieldDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get fieldDisplayName;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters, with letters and numbers'**
  String passwordHelper(int min);

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms of use and the community rules'**
  String get acceptTerms;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

  /// No description provided for @actionSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get actionSignUp;

  /// No description provided for @actionCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get actionCreateAccount;

  /// No description provided for @actionGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get actionGoogle;

  /// No description provided for @actionSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get actionSendResetLink;

  /// No description provided for @actionBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get actionBackToSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get actionLike;

  /// No description provided for @actionEvolve.
  ///
  /// In en, this message translates to:
  /// **'Evolve'**
  String get actionEvolve;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get actionCopyCode;

  /// No description provided for @actionViewTree.
  ///
  /// In en, this message translates to:
  /// **'View the full tree'**
  String get actionViewTree;

  /// No description provided for @actionEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get actionEditProfile;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get noAccountPrompt;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountPrompt;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'This e-mail address is not valid.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least {min} characters long.'**
  String validationPasswordTooShort(int min);

  /// No description provided for @validationPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Use at least one letter and one number.'**
  String get validationPasswordWeak;

  /// No description provided for @validationConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get validationConfirmRequired;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get validationPasswordsMismatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name.'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'The name must be at least {min} characters long.'**
  String validationNameTooShort(int min);

  /// No description provided for @validationNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'The name must be at most {max} characters long.'**
  String validationNameTooLong(int max);

  /// No description provided for @validationAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms to continue.'**
  String get validationAcceptTerms;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'This e-mail address is badly formatted.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect e-mail or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this e-mail.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'This password is too weak.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'This e-mail is already linked to another sign-in method.'**
  String get authErrorDifferentCredential;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get errorNetwork;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do this.'**
  String get errorPermissionDenied;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This content no longer exists.'**
  String get errorNotFound;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutTitle;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to use the app.'**
  String get signOutMessage;

  /// No description provided for @feedTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get feedTrending;

  /// No description provided for @feedLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get feedLatest;

  /// No description provided for @feedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No creations yet'**
  String get feedEmptyTitle;

  /// No description provided for @feedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Load the demo set to see six creations in three trees.'**
  String get feedEmptyMessage;

  /// No description provided for @drawerSeedDemo.
  ///
  /// In en, this message translates to:
  /// **'Load demo creations'**
  String get drawerSeedDemo;

  /// No description provided for @seedInProgress.
  ///
  /// In en, this message translates to:
  /// **'Publishing demo creations…'**
  String get seedInProgress;

  /// No description provided for @seedDone.
  ///
  /// In en, this message translates to:
  /// **'Demo creations published. Pull down to refresh.'**
  String get seedDone;

  /// No description provided for @categoryGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get categoryGame;

  /// No description provided for @categoryWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get categoryWebsite;

  /// No description provided for @categoryTool.
  ///
  /// In en, this message translates to:
  /// **'Tool'**
  String get categoryTool;

  /// No description provided for @categorySimulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get categorySimulation;

  /// No description provided for @categoryApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get categoryApp;

  /// No description provided for @categoryArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get categoryArt;

  /// No description provided for @lineageOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original · Gen {generation}'**
  String lineageOriginal(int generation);

  /// No description provided for @lineageBranchOf.
  ///
  /// In en, this message translates to:
  /// **'Branch of {parent} by {author} · Gen {generation}'**
  String lineageBranchOf(String parent, String author, int generation);

  /// No description provided for @lineageAncestorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Path from the root'**
  String get lineageAncestorsTitle;

  /// No description provided for @lineageIsOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original creation, the root of its tree'**
  String get lineageIsOriginal;

  /// No description provided for @lineageYouAreHere.
  ///
  /// In en, this message translates to:
  /// **'You are here'**
  String get lineageYouAreHere;

  /// No description provided for @lineageEvolutionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct evolutions ({count})'**
  String lineageEvolutionsTitle(int count);

  /// No description provided for @lineageNoEvolutions.
  ///
  /// In en, this message translates to:
  /// **'No evolutions yet. Tap Evolve to start the first branch.'**
  String get lineageNoEvolutions;

  /// No description provided for @generationLabel.
  ///
  /// In en, this message translates to:
  /// **'Gen {generation}'**
  String generationLabel(int generation);

  /// No description provided for @byAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String byAuthor(String name);

  /// No description provided for @creationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Creation not found'**
  String get creationNotFound;

  /// No description provided for @creationStats.
  ///
  /// In en, this message translates to:
  /// **'{views, plural, =1{1 view} other{{views} views}} · {evolutions, plural, =1{1 evolution} other{{evolutions} evolutions}} · {descendants} in its tree'**
  String creationStats(int views, int evolutions, int descendants);

  /// No description provided for @tabPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get tabPreview;

  /// No description provided for @tabCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get tabCode;

  /// No description provided for @tabLineage.
  ///
  /// In en, this message translates to:
  /// **'Lineage'**
  String get tabLineage;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to the clipboard'**
  String get codeCopied;

  /// No description provided for @previewError.
  ///
  /// In en, this message translates to:
  /// **'This creation could not be loaded.'**
  String get previewError;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @profileOriginals.
  ///
  /// In en, this message translates to:
  /// **'Originals ({count})'**
  String profileOriginals(int count);

  /// No description provided for @profileEvolutions.
  ///
  /// In en, this message translates to:
  /// **'Branches ({count})'**
  String profileEvolutions(int count);

  /// No description provided for @profileNoOriginals.
  ///
  /// In en, this message translates to:
  /// **'No original creations yet'**
  String get profileNoOriginals;

  /// No description provided for @profileNoEvolutions.
  ///
  /// In en, this message translates to:
  /// **'No evolutions yet'**
  String get profileNoEvolutions;

  /// No description provided for @statGenerations.
  ///
  /// In en, this message translates to:
  /// **'Generations'**
  String get statGenerations;

  /// No description provided for @statDescendants.
  ///
  /// In en, this message translates to:
  /// **'Descendants'**
  String get statDescendants;

  /// No description provided for @statLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get statLikes;

  /// No description provided for @statEvolutions.
  ///
  /// In en, this message translates to:
  /// **'Evolutions'**
  String get statEvolutions;

  /// No description provided for @pointsValue.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String pointsValue(int points);

  /// No description provided for @pointsToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{points} pts to reach {level}'**
  String pointsToNextLevel(int points, String level);

  /// No description provided for @pointsHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How points work'**
  String get pointsHowTitle;

  /// No description provided for @pointsRulePublish.
  ///
  /// In en, this message translates to:
  /// **'+{points} for each creation you publish'**
  String pointsRulePublish(int points);

  /// No description provided for @pointsRuleLike.
  ///
  /// In en, this message translates to:
  /// **'+{points} when someone likes your creation'**
  String pointsRuleLike(int points);

  /// No description provided for @pointsRuleEvolution.
  ///
  /// In en, this message translates to:
  /// **'+{points} when someone evolves your creation'**
  String pointsRuleEvolution(int points);

  /// No description provided for @pointsRuleDescendant.
  ///
  /// In en, this message translates to:
  /// **'+{points} for every evolution further down your tree'**
  String pointsRuleDescendant(int points);

  /// No description provided for @levelSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get levelSeed;

  /// No description provided for @levelSprout.
  ///
  /// In en, this message translates to:
  /// **'Sprout'**
  String get levelSprout;

  /// No description provided for @levelSapling.
  ///
  /// In en, this message translates to:
  /// **'Sapling'**
  String get levelSapling;

  /// No description provided for @levelTree.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get levelTree;

  /// No description provided for @levelForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get levelForest;

  /// No description provided for @levelMax.
  ///
  /// In en, this message translates to:
  /// **'Top level reached'**
  String get levelMax;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get themeToggle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageSystem;

  /// No description provided for @firebaseSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Firebase setup needed'**
  String get firebaseSetupTitle;

  /// No description provided for @firebaseSetupMessage.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured for this build yet. From the project folder, run the commands below, then restart the app.'**
  String get firebaseSetupMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

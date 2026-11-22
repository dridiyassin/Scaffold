// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Scaffold';

  @override
  String get appTagline =>
      'Play mini-games and tiny apps, then build your own on top';

  @override
  String get loading => 'Loading…';

  @override
  String get menu => 'Menu';

  @override
  String get navFeed => 'Feed';

  @override
  String get navExplore => 'Explore';

  @override
  String get navCreate => 'Create';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get featureEditor => 'Code editor';

  @override
  String get featureTree => 'Evolution tree';

  @override
  String get featurePremium => 'Premium';

  @override
  String get comingSoonMessage => 'Planned for Part 2 of the project';

  @override
  String get routeNotFound => 'Page not found';

  @override
  String get loginTitle => 'Sign in to Scaffold';

  @override
  String get loginSubtitle => 'With your e-mail or your Google account';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Each creation you publish starts a new tree';

  @override
  String get registerSuccess => 'Account created';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotSubtitle =>
      'We\'ll e-mail you a link to choose a new password';

  @override
  String forgotSent(String email) {
    return 'A reset link was sent to $email. Check your inbox.';
  }

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get fieldDisplayName => 'Display name';

  @override
  String passwordHelper(int min) {
    return 'At least $min characters, with letters and numbers';
  }

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get acceptTerms => 'I accept the terms of use and the community rules';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get actionSignUp => 'Sign up';

  @override
  String get actionCreateAccount => 'Create account';

  @override
  String get actionGoogle => 'Continue with Google';

  @override
  String get actionSendResetLink => 'Send reset link';

  @override
  String get actionBackToSignIn => 'Back to sign in';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionLike => 'Like';

  @override
  String get actionEvolve => 'Evolve';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionCopyCode => 'Copy code';

  @override
  String get actionViewTree => 'View the full tree';

  @override
  String get actionEditProfile => 'Edit profile';

  @override
  String get orDivider => 'or';

  @override
  String get noAccountPrompt => 'No account yet?';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get validationEmailRequired => 'Please enter your e-mail.';

  @override
  String get validationEmailInvalid => 'This e-mail address is not valid.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String validationPasswordTooShort(int min) {
    return 'The password must be at least $min characters long.';
  }

  @override
  String get validationPasswordWeak =>
      'Use at least one letter and one number.';

  @override
  String get validationConfirmRequired => 'Please confirm your password.';

  @override
  String get validationPasswordsMismatch => 'The passwords do not match.';

  @override
  String get validationNameRequired => 'Please enter a display name.';

  @override
  String validationNameTooShort(int min) {
    return 'The name must be at least $min characters long.';
  }

  @override
  String validationNameTooLong(int max) {
    return 'The name must be at most $max characters long.';
  }

  @override
  String get validationAcceptTerms => 'You must accept the terms to continue.';

  @override
  String get authErrorInvalidEmail => 'This e-mail address is badly formatted.';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorInvalidCredentials => 'Incorrect e-mail or password.';

  @override
  String get authErrorEmailInUse =>
      'An account already exists with this e-mail.';

  @override
  String get authErrorWeakPassword => 'This password is too weak.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrorDifferentCredential =>
      'This e-mail is already linked to another sign-in method.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorGeneric => 'An unexpected error occurred. Please try again.';

  @override
  String get errorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get errorPermissionDenied => 'You do not have permission to do this.';

  @override
  String get errorNotFound => 'This content no longer exists.';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutMessage => 'You will need to sign in again to use the app.';

  @override
  String get feedTrending => 'Trending';

  @override
  String get feedLatest => 'Latest';

  @override
  String get feedEmptyTitle => 'No creations yet';

  @override
  String get feedEmptyMessage =>
      'Load the demo set to see six creations in three trees.';

  @override
  String get drawerSeedDemo => 'Load demo creations';

  @override
  String get seedInProgress => 'Publishing demo creations…';

  @override
  String get seedDone => 'Demo creations published. Pull down to refresh.';

  @override
  String get categoryGame => 'Game';

  @override
  String get categoryWebsite => 'Website';

  @override
  String get categoryTool => 'Tool';

  @override
  String get categorySimulation => 'Simulation';

  @override
  String get categoryApp => 'App';

  @override
  String get categoryArt => 'Art';

  @override
  String lineageOriginal(int generation) {
    return 'Original · Gen $generation';
  }

  @override
  String lineageBranchOf(String parent, String author, int generation) {
    return 'Branch of $parent by $author · Gen $generation';
  }

  @override
  String get lineageAncestorsTitle => 'Path from the root';

  @override
  String get lineageIsOriginal => 'Original creation, the root of its tree';

  @override
  String get lineageYouAreHere => 'You are here';

  @override
  String lineageEvolutionsTitle(int count) {
    return 'Direct evolutions ($count)';
  }

  @override
  String get lineageNoEvolutions =>
      'No evolutions yet. Tap Evolve to start the first branch.';

  @override
  String generationLabel(int generation) {
    return 'Gen $generation';
  }

  @override
  String byAuthor(String name) {
    return 'by $name';
  }

  @override
  String get creationNotFound => 'Creation not found';

  @override
  String creationStats(int views, int evolutions, int descendants) {
    String _temp0 = intl.Intl.pluralLogic(
      views,
      locale: localeName,
      other: '$views views',
      one: '1 view',
    );
    String _temp1 = intl.Intl.pluralLogic(
      evolutions,
      locale: localeName,
      other: '$evolutions evolutions',
      one: '1 evolution',
    );
    return '$_temp0 · $_temp1 · $descendants in its tree';
  }

  @override
  String get tabPreview => 'Preview';

  @override
  String get tabCode => 'Code';

  @override
  String get tabLineage => 'Lineage';

  @override
  String get codeCopied => 'Code copied to the clipboard';

  @override
  String get previewError => 'This creation could not be loaded.';

  @override
  String get userNotFound => 'User not found';

  @override
  String profileOriginals(int count) {
    return 'Originals ($count)';
  }

  @override
  String profileEvolutions(int count) {
    return 'Branches ($count)';
  }

  @override
  String get profileNoOriginals => 'No original creations yet';

  @override
  String get profileNoEvolutions => 'No evolutions yet';

  @override
  String get statGenerations => 'Generations';

  @override
  String get statDescendants => 'Descendants';

  @override
  String get statLikes => 'Likes';

  @override
  String get statEvolutions => 'Evolutions';

  @override
  String pointsValue(int points) {
    return '$points pts';
  }

  @override
  String pointsToNextLevel(int points, String level) {
    return '$points pts to reach $level';
  }

  @override
  String get pointsHowTitle => 'How points work';

  @override
  String pointsRulePublish(int points) {
    return '+$points for each creation you publish';
  }

  @override
  String pointsRuleLike(int points) {
    return '+$points when someone likes your creation';
  }

  @override
  String pointsRuleEvolution(int points) {
    return '+$points when someone evolves your creation';
  }

  @override
  String pointsRuleDescendant(int points) {
    return '+$points for every evolution further down your tree';
  }

  @override
  String get levelSeed => 'Seed';

  @override
  String get levelSprout => 'Sprout';

  @override
  String get levelSapling => 'Sapling';

  @override
  String get levelTree => 'Tree';

  @override
  String get levelForest => 'Forest';

  @override
  String get levelMax => 'Top level reached';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeToggle => 'Toggle theme';

  @override
  String get languageSystem => 'Device language';

  @override
  String get firebaseSetupTitle => 'Firebase setup needed';

  @override
  String get firebaseSetupMessage =>
      'Firebase is not configured for this build yet. From the project folder, run the commands below, then restart the app.';
}

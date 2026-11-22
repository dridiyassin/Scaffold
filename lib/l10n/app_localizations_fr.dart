// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Scaffold';

  @override
  String get appTagline =>
      'Jouez à des mini-jeux, testez de petites apps, puis construisez votre version par-dessus';

  @override
  String get loading => 'Chargement…';

  @override
  String get menu => 'Menu';

  @override
  String get navFeed => 'Fil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navCreate => 'Créer';

  @override
  String get navInbox => 'Activité';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navLeaderboard => 'Classement';

  @override
  String get featureEditor => 'Éditeur de code';

  @override
  String get featureTree => 'Arbre d\'évolution';

  @override
  String get featurePremium => 'Premium';

  @override
  String get comingSoonMessage => 'Prévu pour la partie 2 du projet';

  @override
  String get routeNotFound => 'Page introuvable';

  @override
  String get loginTitle => 'Connexion à Scaffold';

  @override
  String get loginSubtitle => 'Avec votre e-mail ou votre compte Google';

  @override
  String get registerTitle => 'Créez votre compte';

  @override
  String get registerSubtitle =>
      'Chaque création publiée démarre un nouvel arbre';

  @override
  String get registerSuccess => 'Compte créé';

  @override
  String get forgotTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotSubtitle =>
      'Nous vous enverrons par e-mail un lien pour choisir un nouveau mot de passe';

  @override
  String forgotSent(String email) {
    return 'Un lien a été envoyé à $email. Vérifiez votre boîte de réception.';
  }

  @override
  String get forgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPassword => 'Mot de passe';

  @override
  String get fieldConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get fieldDisplayName => 'Nom d\'affichage';

  @override
  String passwordHelper(int min) {
    return 'Au moins $min caractères, avec des lettres et des chiffres';
  }

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get acceptTerms =>
      'J\'accepte les conditions d\'utilisation et les règles de la communauté';

  @override
  String get actionSignIn => 'Se connecter';

  @override
  String get actionSignUp => 'S\'inscrire';

  @override
  String get actionCreateAccount => 'Créer le compte';

  @override
  String get actionGoogle => 'Continuer avec Google';

  @override
  String get actionSendResetLink => 'Envoyer le lien';

  @override
  String get actionBackToSignIn => 'Retour à la connexion';

  @override
  String get actionSignOut => 'Se déconnecter';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionLike => 'J\'aime';

  @override
  String get actionEvolve => 'Faire évoluer';

  @override
  String get actionOpen => 'Ouvrir';

  @override
  String get actionCopyCode => 'Copier le code';

  @override
  String get actionViewTree => 'Voir l\'arbre complet';

  @override
  String get actionEditProfile => 'Modifier le profil';

  @override
  String get orDivider => 'ou';

  @override
  String get noAccountPrompt => 'Pas encore de compte ?';

  @override
  String get haveAccountPrompt => 'Déjà un compte ?';

  @override
  String get validationEmailRequired => 'Veuillez saisir votre e-mail.';

  @override
  String get validationEmailInvalid =>
      'Cette adresse e-mail n\'est pas valide.';

  @override
  String get validationPasswordRequired =>
      'Veuillez saisir votre mot de passe.';

  @override
  String validationPasswordTooShort(int min) {
    return 'Le mot de passe doit contenir au moins $min caractères.';
  }

  @override
  String get validationPasswordWeak =>
      'Utilisez au moins une lettre et un chiffre.';

  @override
  String get validationConfirmRequired =>
      'Veuillez confirmer votre mot de passe.';

  @override
  String get validationPasswordsMismatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get validationNameRequired => 'Veuillez saisir un nom d\'affichage.';

  @override
  String validationNameTooShort(int min) {
    return 'Le nom doit contenir au moins $min caractères.';
  }

  @override
  String validationNameTooLong(int max) {
    return 'Le nom doit contenir au plus $max caractères.';
  }

  @override
  String get validationAcceptTerms =>
      'Vous devez accepter les conditions pour continuer.';

  @override
  String get authErrorInvalidEmail => 'Cette adresse e-mail est mal formée.';

  @override
  String get authErrorUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get authErrorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get authErrorEmailInUse => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get authErrorWeakPassword => 'Ce mot de passe est trop faible.';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Réessayez plus tard.';

  @override
  String get authErrorDifferentCredential =>
      'Cet e-mail est déjà associé à une autre méthode de connexion.';

  @override
  String get errorTitle => 'Une erreur est survenue';

  @override
  String get errorGeneric =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion. Vérifiez votre internet et réessayez.';

  @override
  String get errorPermissionDenied =>
      'Vous n\'avez pas l\'autorisation de faire cela.';

  @override
  String get errorNotFound => 'Ce contenu n\'existe plus.';

  @override
  String get signOutTitle => 'Se déconnecter ?';

  @override
  String get signOutMessage =>
      'Vous devrez vous reconnecter pour utiliser l\'application.';

  @override
  String get feedTrending => 'Tendances';

  @override
  String get feedLatest => 'Récents';

  @override
  String get feedEmptyTitle => 'Aucune création pour l\'instant';

  @override
  String get feedEmptyMessage =>
      'Chargez la démo pour voir six créations réparties en trois arbres.';

  @override
  String get drawerSeedDemo => 'Charger les créations de démo';

  @override
  String get seedInProgress => 'Publication des créations de démo…';

  @override
  String get seedDone =>
      'Créations de démo publiées. Tirez vers le bas pour actualiser.';

  @override
  String get categoryGame => 'Jeu';

  @override
  String get categoryWebsite => 'Site web';

  @override
  String get categoryTool => 'Outil';

  @override
  String get categorySimulation => 'Simulation';

  @override
  String get categoryApp => 'Application';

  @override
  String get categoryArt => 'Art';

  @override
  String lineageOriginal(int generation) {
    return 'Original · Gén. $generation';
  }

  @override
  String lineageBranchOf(String parent, String author, int generation) {
    return 'Branche de $parent par $author · Gén. $generation';
  }

  @override
  String get lineageAncestorsTitle => 'Chemin depuis la racine';

  @override
  String get lineageIsOriginal => 'Création originale, la racine de son arbre';

  @override
  String get lineageYouAreHere => 'Vous êtes ici';

  @override
  String lineageEvolutionsTitle(int count) {
    return 'Évolutions directes ($count)';
  }

  @override
  String get lineageNoEvolutions =>
      'Aucune évolution pour l\'instant. Touchez Faire évoluer pour créer la première branche.';

  @override
  String generationLabel(int generation) {
    return 'Gén. $generation';
  }

  @override
  String byAuthor(String name) {
    return 'par $name';
  }

  @override
  String get creationNotFound => 'Création introuvable';

  @override
  String creationStats(int views, int evolutions, int descendants) {
    String _temp0 = intl.Intl.pluralLogic(
      views,
      locale: localeName,
      other: '$views vues',
      one: '1 vue',
      zero: '0 vue',
    );
    String _temp1 = intl.Intl.pluralLogic(
      evolutions,
      locale: localeName,
      other: '$evolutions évolutions',
      one: '1 évolution',
      zero: '0 évolution',
    );
    return '$_temp0 · $_temp1 · $descendants dans son arbre';
  }

  @override
  String get tabPreview => 'Aperçu';

  @override
  String get tabCode => 'Code';

  @override
  String get tabLineage => 'Lignée';

  @override
  String get codeCopied => 'Code copié dans le presse-papiers';

  @override
  String get previewError => 'Impossible de charger cette création.';

  @override
  String get userNotFound => 'Utilisateur introuvable';

  @override
  String profileOriginals(int count) {
    return 'Originaux ($count)';
  }

  @override
  String profileEvolutions(int count) {
    return 'Branches ($count)';
  }

  @override
  String get profileNoOriginals => 'Aucune création originale pour l\'instant';

  @override
  String get profileNoEvolutions => 'Aucune évolution pour l\'instant';

  @override
  String get statGenerations => 'Générations';

  @override
  String get statDescendants => 'Descendants';

  @override
  String get statLikes => 'J\'aime';

  @override
  String get statEvolutions => 'Évolutions';

  @override
  String pointsValue(int points) {
    return '$points pts';
  }

  @override
  String pointsToNextLevel(int points, String level) {
    return 'Encore $points pts pour atteindre $level';
  }

  @override
  String get pointsHowTitle => 'Comment gagner des points';

  @override
  String pointsRulePublish(int points) {
    return '+$points pour chaque création publiée';
  }

  @override
  String pointsRuleLike(int points) {
    return '+$points quand quelqu\'un aime votre création';
  }

  @override
  String pointsRuleEvolution(int points) {
    return '+$points quand quelqu\'un fait évoluer votre création';
  }

  @override
  String pointsRuleDescendant(int points) {
    return '+$points pour chaque évolution plus bas dans votre arbre';
  }

  @override
  String get levelSeed => 'Graine';

  @override
  String get levelSprout => 'Pousse';

  @override
  String get levelSapling => 'Jeune arbre';

  @override
  String get levelTree => 'Arbre';

  @override
  String get levelForest => 'Forêt';

  @override
  String get levelMax => 'Niveau maximum atteint';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeToggle => 'Changer de thème';

  @override
  String get languageSystem => 'Langue de l\'appareil';

  @override
  String get firebaseSetupTitle => 'Configuration Firebase requise';

  @override
  String get firebaseSetupMessage =>
      'Firebase n\'est pas encore configuré pour cette version. Depuis le dossier du projet, exécutez les commandes ci-dessous puis relancez l\'application.';
}

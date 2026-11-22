import '../../l10n/app_localizations.dart';

/// Form validators returning a localized error message, or null when valid.
abstract final class Validators {
  static final _email = RegExp(r"^[\w.+\-']+@[\w\-]+(\.[\w\-]+)+$");
  static final _letter = RegExp(r'[A-Za-z؀-ۿ]');
  static final _digit = RegExp(r'\d');

  static const minPasswordLength = 8;
  static const minNameLength = 2;
  static const maxNameLength = 40;

  static String? email(AppLocalizations l, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l.validationEmailRequired;
    if (!_email.hasMatch(v)) return l.validationEmailInvalid;
    return null;
  }

  /// Password on the login form: only checks it is present.
  static String? loginPassword(AppLocalizations l, String? value) =>
      (value == null || value.isEmpty) ? l.validationPasswordRequired : null;

  /// Password on the sign-up form: length + at least one letter and digit.
  static String? newPassword(AppLocalizations l, String? value) {
    final v = value ?? '';
    if (v.isEmpty) return l.validationPasswordRequired;
    if (v.length < minPasswordLength) {
      return l.validationPasswordTooShort(minPasswordLength);
    }
    if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) {
      return l.validationPasswordWeak;
    }
    return null;
  }

  static String? confirmPassword(
    AppLocalizations l,
    String? value,
    String original,
  ) {
    if (value == null || value.isEmpty) return l.validationConfirmRequired;
    if (value != original) return l.validationPasswordsMismatch;
    return null;
  }

  static String? displayName(AppLocalizations l, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l.validationNameRequired;
    if (v.length < minNameLength) {
      return l.validationNameTooShort(minNameLength);
    }
    if (v.length > maxNameLength) return l.validationNameTooLong(maxNameLength);
    return null;
  }
}

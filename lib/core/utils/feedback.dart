import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' show Bidi, DateFormat, NumberFormat;
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

/// Shows a floating SnackBar, replacing the current one.
void showAppSnack(BuildContext context, String message, {bool error = false}) {
  final scheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error ? scheme.error : null,
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline_rounded : Icons.check_circle_outline,
              color: error ? scheme.onError : scheme.onInverseSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: error ? scheme.onError : scheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

/// Turns any exception into a user-friendly localized message.
String describeError(AppLocalizations l, Object error) {
  if (error is FirebaseAuthException) return authErrorMessage(l, error.code);
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' => l.errorPermissionDenied,
      'unavailable' => l.errorNetwork,
      'not-found' => l.errorNotFound,
      _ => l.errorGeneric,
    };
  }
  return l.errorGeneric;
}

/// Maps FirebaseAuth error codes to clear localized messages.
String authErrorMessage(AppLocalizations l, String code) => switch (code) {
  'invalid-email' => l.authErrorInvalidEmail,
  'user-disabled' => l.authErrorUserDisabled,
  'user-not-found' ||
  'wrong-password' ||
  'invalid-credential' ||
  'INVALID_LOGIN_CREDENTIALS' => l.authErrorInvalidCredentials,
  'email-already-in-use' => l.authErrorEmailInUse,
  'weak-password' => l.authErrorWeakPassword,
  'too-many-requests' => l.authErrorTooManyRequests,
  'network-request-failed' => l.errorNetwork,
  'account-exists-with-different-credential' => l.authErrorDifferentCredential,
  _ => l.errorGeneric,
};

/// 1234 -> "1.2K" in the current locale.
String compactNumber(BuildContext context, int value) =>
    NumberFormat.compact(locale: Localizations.localeOf(context).languageCode)
        .format(value);

/// Direction of user-written text (titles, descriptions, handles), detected
/// from its letters rather than the app language, so English text keeps its
/// punctuation in place inside the Arabic UI and vice versa.
TextDirection contentDirection(String text) =>
    Bidi.detectRtlDirectionality(text) ? TextDirection.rtl : TextDirection.ltr;

/// Localized short date, e.g. "27 nov. 2026". Always Western digits, so
/// Arabic screens never mix ٢٧ with the 27 used by counts and points.
String shortDate(BuildContext context, DateTime? date) => date == null
    ? ''
    : (DateFormat.yMMMd(
        Localizations.localeOf(context).languageCode,
      )..useNativeDigits = false).format(date);

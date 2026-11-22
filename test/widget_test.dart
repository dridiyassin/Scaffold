import 'package:flutter_test/flutter_test.dart';
import 'package:scaffold/core/gamification.dart';
import 'package:scaffold/core/utils/validators.dart';
import 'package:scaffold/l10n/app_localizations_en.dart';

void main() {
  final l = AppLocalizationsEn();

  group('Validators', () {
    test('email', () {
      expect(Validators.email(l, ''), l.validationEmailRequired);
      expect(Validators.email(l, 'not-an-email'), l.validationEmailInvalid);
      expect(Validators.email(l, ' ada@example.com '), isNull);
    });

    test('new password', () {
      expect(Validators.newPassword(l, ''), l.validationPasswordRequired);
      expect(
        Validators.newPassword(l, 'abc1'),
        l.validationPasswordTooShort(Validators.minPasswordLength),
      );
      expect(Validators.newPassword(l, 'abcdefgh'), l.validationPasswordWeak);
      expect(Validators.newPassword(l, 'abcdefg1'), isNull);
    });

    test('confirm password', () {
      expect(
        Validators.confirmPassword(l, 'x', 'y'),
        l.validationPasswordsMismatch,
      );
      expect(Validators.confirmPassword(l, 'same', 'same'), isNull);
    });

    test('display name', () {
      expect(Validators.displayName(l, ' '), l.validationNameRequired);
      expect(Validators.displayName(l, 'A'), l.validationNameTooShort(2));
      expect(Validators.displayName(l, 'Ada'), isNull);
    });
  });

  group('CreatorLevel', () {
    test('levels by points', () {
      expect(CreatorLevel.forPoints(0), CreatorLevel.seed);
      expect(CreatorLevel.forPoints(60), CreatorLevel.sprout);
      expect(CreatorLevel.forPoints(99999), CreatorLevel.forest);
    });

    test('progress to next level', () {
      expect(CreatorLevel.seed.progress(25), closeTo(0.5, 1e-9));
      expect(CreatorLevel.forest.progress(5000), 1);
      expect(CreatorLevel.forest.next, isNull);
    });
  });
}

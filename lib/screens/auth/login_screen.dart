import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/routing/app_routes.dart';
import '../../core/utils/feedback.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import 'auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _setBusy(bool google, bool value) => setState(() {
    if (google) {
      _googleLoading = value;
    } else {
      _loading = value;
    }
  });

  /// Runs a sign-in [action]; on success (true) opens the home screen,
  /// on failure shows a clear error SnackBar.
  Future<void> _run(
    Future<bool> Function() action, {
    bool google = false,
  }) async {
    final l10n = context.l10n;
    FocusScope.of(context).unfocus();
    _setBusy(google, true);
    try {
      final signedIn = await action();
      if (!mounted || !signedIn) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } catch (e) {
      if (mounted) showAppSnack(context, describeError(l10n, e), error: true);
    } finally {
      if (mounted) _setBusy(google, false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthService>();
    _run(() async {
      await auth.signInWithEmail(_email.text, _password.text);
      return true;
    });
  }

  void _google() {
    final auth = context.read<AuthService>();
    _run(() async => await auth.signInWithGoogle() != null, google: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = _loading || _googleLoading;
    return AuthLayout(
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(labelText: l10n.fieldEmail),
              validator: (v) => Validators.email(l10n, v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.fieldPassword,
                suffixIcon: IconButton(
                  tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) => Validators.loginPassword(l10n, v),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: busy
                    ? null
                    : () => Navigator.of(context).pushNamed(
                        AppRoutes.forgotPassword,
                        arguments: _email.text.trim(),
                      ),
                child: Text(l10n.forgotPasswordLink),
              ),
            ),
            const SizedBox(height: 8),
            LoadingButton(
              label: l10n.actionSignIn,
              loading: _loading,
              onPressed: busy ? null : _submit,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(l10n.orDivider),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            // No drawn copy of Google's logo: the label says it.
            OutlinedButton(
              onPressed: busy ? null : _google,
              child: _googleLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.actionGoogle),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(l10n.noAccountPrompt)),
                TextButton(
                  onPressed: busy
                      ? null
                      : () =>
                            Navigator.of(context).pushNamed(AppRoutes.register),
                  child: Text(l10n.actionSignUp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/routing/app_routes.dart';
import '../../core/utils/feedback.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import 'auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    final auth = context.read<AuthService>();
    setState(() => _loading = true);
    try {
      await auth.register(
        displayName: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      showAppSnack(context, l10n.registerSuccess);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } catch (e) {
      if (mounted) showAppSnack(context, describeError(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visibility = IconButton(
      tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      onPressed: () => setState(() => _obscure = !_obscure),
    );

    return AuthLayout(
      showBack: true,
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: Validators.maxNameLength,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(labelText: l10n.fieldDisplayName),
              validator: (v) => Validators.displayName(l10n, v),
            ),
            const SizedBox(height: 8),
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
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: l10n.fieldPassword,
                helperText: l10n.passwordHelper(Validators.minPasswordLength),
                suffixIcon: visibility,
              ),
              validator: (v) => Validators.newPassword(l10n, v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirm,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(labelText: l10n.fieldConfirmPassword),
              validator: (v) =>
                  Validators.confirmPassword(l10n, v, _password.text),
            ),
            const SizedBox(height: 8),
            // Custom FormField: the terms checkbox is validated like a field.
            FormField<bool>(
              initialValue: false,
              validator: (v) => v == true ? null : l10n.validationAcceptTerms,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    value: field.value,
                    onChanged: field.didChange,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l10n.acceptTerms),
                  ),
                  if (field.hasError)
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LoadingButton(
              label: l10n.actionCreateAccount,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(l10n.haveAccountPrompt)),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(l10n.actionSignIn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

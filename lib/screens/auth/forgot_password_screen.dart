import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/feedback.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import 'auth_layout.dart';

/// Sends a FirebaseAuth password-reset e-mail. Receives the e-mail already
/// typed on the login screen as a route argument.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    setState(() => _loading = true);
    try {
      await context.read<AuthService>().sendPasswordReset(_email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) showAppSnack(context, describeError(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return AuthLayout(
      showBack: true,
      title: l10n.forgotTitle,
      subtitle: l10n.forgotSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              enabled: !_sent,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(labelText: l10n.fieldEmail),
              validator: (v) => Validators.email(l10n, v),
            ),
            const SizedBox(height: 20),
            LoadingButton(
              label: l10n.actionSendResetLink,
              loading: _loading,
              onPressed: _sent ? null : _submit,
            ),
            const SizedBox(height: 20),
            // Success message fades and grows in once the e-mail is sent.
            AnimatedOpacity(
              opacity: _sent ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              curve: AppTheme.ease,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: AppTheme.ease,
                padding: EdgeInsets.all(_sent ? 16 : 0),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: _sent
                    ? Row(
                        children: [
                          Icon(
                            Icons.mark_email_read_outlined,
                            size: 20,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(l10n.forgotSent(_email.text.trim())),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            if (_sent)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.actionBackToSignIn),
              ),
          ],
        ),
      ),
    );
  }
}

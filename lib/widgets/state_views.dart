import 'package:material_ui/material_ui.dart';

import '../core/l10n_ext.dart';
import '../core/theme/app_theme.dart';

/// Centered spinner with an optional message.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message, this.onDark = false});

  final String? message;

  /// Use light colours (e.g. on the black feed background).
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark ? Colors.white : null;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: TextStyle(color: color)),
          ],
        ],
      ),
    );
  }
}

/// Error state with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.onDark = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool onDark;

  @override
  Widget build(BuildContext context) => _MessageView(
    icon: Icons.cloud_off_outlined,
    iconColor: onDark ? Colors.white54 : Theme.of(context).colorScheme.outline,
    title: context.l10n.errorTitle,
    message: message,
    onDark: onDark,
    action: onRetry == null
        ? null
        : FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.actionRetry),
          ),
  );
}

/// Empty state (nothing to show yet).
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.onDark = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final bool onDark;

  @override
  Widget build(BuildContext context) => _MessageView(
    icon: icon,
    iconColor: onDark ? Colors.white54 : Theme.of(context).colorScheme.outline,
    title: title,
    message: message,
    action: action,
    onDark: onDark,
  );
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onDark,
    this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final Widget? action;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fg = onDark ? Colors.white : null;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          curve: AppTheme.ease,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - t)),
              child: child,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: iconColor),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: text.titleMedium?.copyWith(color: fg),
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: onDark
                        ? Colors.white70
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (action != null) ...[const SizedBox(height: 24), action!],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../core/l10n_ext.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/feedback.dart';
import '../models/creation.dart';
import '../providers/session_provider.dart';
import '../services/creation_service.dart';

/// Animated heart with a counter. Likes give points to the author.
class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.creation,
    this.onDark = false,
    this.vertical = true,
  });

  final Creation creation;
  final bool onDark;

  /// Icon above the count (feed rail) or beside it (detail header).
  final bool vertical;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Stream<bool>? _liked;
  String? _streamKey;

  /// Value shown while the transaction is running (optimistic UI).
  bool? _pending;

  void _ensureStream() {
    final uid = context.read<SessionProvider>().uid;
    final key = '${widget.creation.id}/$uid';
    if (uid == null || key == _streamKey) return;
    _streamKey = key;
    _liked = context.read<CreationService>().isLikedBy(widget.creation.id, uid);
  }

  Future<void> _toggle(bool current) async {
    final uid = context.read<SessionProvider>().uid;
    if (uid == null || _pending != null) return;
    final l10n = context.l10n;
    setState(() => _pending = !current);
    try {
      await context.read<CreationService>().toggleLike(widget.creation, uid);
    } catch (e) {
      if (mounted) showAppSnack(context, describeError(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _pending = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureStream();
    return StreamBuilder<bool>(
      stream: _liked,
      builder: (context, snap) {
        final stored = snap.data ?? false;
        final liked = _pending ?? stored;
        var count = widget.creation.likesCount;
        if (_pending != null && _pending != stored) count += liked ? 1 : -1;

        final idle = widget.onDark
            ? Colors.white
            : Theme.of(context).colorScheme.onSurfaceVariant;
        // The heart changes colour and grows a little; no bounce, no halo.
        final heart = Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedScale(
            scale: liked ? 1.08 : 1,
            duration: const Duration(milliseconds: 160),
            curve: AppTheme.ease,
            child: Icon(
              liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: liked ? AppTheme.like : idle,
              size: widget.vertical ? 28 : 22,
              shadows: widget.onDark
                  ? const [Shadow(blurRadius: 8, color: Colors.black45)]
                  : null,
            ),
          ),
        );
        final label = Text(
          compactNumber(context, count < 0 ? 0 : count),
          style:
              AppTheme.figures(
                fontSize: widget.vertical ? 12 : 13,
                color: widget.onDark ? Colors.white : idle,
              ).copyWith(
                shadows: widget.onDark
                    ? const [Shadow(blurRadius: 8, color: Colors.black45)]
                    : null,
              ),
        );

        return Semantics(
          button: true,
          label: context.l10n.actionLike,
          child: InkResponse(
            onTap: () => _toggle(liked),
            radius: 28,
            child: widget.vertical
                ? SizedBox(
                    width: 56,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [heart, label],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [heart, const SizedBox(width: 4), label],
                  ),
          ),
        );
      },
    );
  }
}

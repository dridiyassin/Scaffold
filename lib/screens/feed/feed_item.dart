import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/category_ui.dart';
import '../../core/l10n_ext.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/feedback.dart';
import '../../models/creation.dart';
import '../../services/creation_service.dart';
import '../../widgets/creation_cover.dart';
import '../../widgets/creation_preview.dart';
import '../../widgets/like_button.dart';
import '../../widgets/lineage_chip.dart';
import '../../widgets/user_avatar.dart';

/// One full-screen page of the feed: the running creation, its info at the
/// bottom and the action rail (like / evolve / branches / open) on the side.
class FeedItem extends StatefulWidget {
  const FeedItem({
    super.key,
    required this.creation,
    required this.active,
    required this.heroTag,
  });

  final Creation creation;

  /// Only the visible page runs its WebView; others show the cover.
  final bool active;
  final String heroTag;

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  /// Live document so counters update while the page is displayed.
  late Stream<Creation?> _live = _watch();

  Stream<Creation?> _watch() =>
      context.read<CreationService>().watch(widget.creation.id);

  @override
  void didUpdateWidget(FeedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.creation.id != widget.creation.id) _live = _watch();
  }

  @override
  Widget build(BuildContext context) {
    final creation = widget.creation;
    final heroTag = widget.heroTag;
    // Stop the WebView when another route covers the feed or when another
    // bottom tab is selected (IndexedStack disables tickers when hidden).
    final routeVisible = ModalRoute.of(context)?.isCurrent ?? true;
    final tabVisible = TickerMode.valuesOf(context).enabled;
    final live = widget.active && routeVisible && tabVisible;
    // The feed Scaffold extends its body behind the app bar, so this padding
    // already covers the status bar and the app bar.
    final top = MediaQuery.paddingOf(context).top;

    return StreamBuilder<Creation?>(
      stream: _live,
      initialData: creation,
      builder: (context, snap) {
        final c = snap.data ?? creation;
        return Stack(
          fit: StackFit.expand,
          children: [
            CreationCover(creation: c),
            if (live)
              Padding(
                padding: EdgeInsets.only(top: top),
                child: CreationPreview(key: ValueKey(c.id), code: c.code),
              ),
            const IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 16,
              end: 80,
              bottom: 24,
              child: _InfoBlock(creation: c, heroTag: heroTag),
            ),
            PositionedDirectional(
              end: 8,
              bottom: 24,
              child: _ActionRail(creation: c, heroTag: heroTag),
            ),
          ],
        );
      },
    );
  }
}

void _openDetail(
  BuildContext context,
  Creation creation, {
  String? heroTag,
  int tab = 0,
}) => Navigator.of(context).pushNamed(
  AppRoutes.creationDetail,
  arguments: CreationDetailArgs(
    creationId: creation.id,
    initial: creation,
    heroTag: heroTag,
    initialTab: tab,
  ),
);

void _openAuthor(BuildContext context, Creation creation) =>
    Navigator.of(context).pushNamed(
      AppRoutes.userProfile,
      arguments: UserProfileArgs(creation.authorId),
    );

/// Keeps white text readable over bright creations.
const _textShadow = [Shadow(blurRadius: 8, color: Colors.black45)];

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.creation, required this.heroTag});

  final Creation creation;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => _openAuthor(context, creation),
                child: Text(
                  '@${creation.authorUsername}',
                  // Handles are Latin: keep the "@" in front in Arabic too.
                  textDirection: TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.figures(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ).copyWith(shadows: _textShadow),
                ),
              ),
            ),
            Text(
              '  ·  ${creation.category.label(l10n)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                shadows: _textShadow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openDetail(context, creation, heroTag: heroTag),
          child: Hero(
            tag: heroTag,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                creation.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  shadows: _textShadow,
                ),
              ),
            ),
          ),
        ),
        if (creation.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            creation.description,
            textDirection: contentDirection(creation.description),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.45,
              shadows: _textShadow,
            ),
          ),
        ],
        const SizedBox(height: 8),
        LineageChip(creation: creation, onDark: true),
      ],
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({required this.creation, required this.heroTag});

  final Creation creation;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _openAuthor(context, creation),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: UserAvatar(
              name: creation.authorName,
              photoUrl: creation.authorPhotoUrl,
              radius: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        LikeButton(creation: creation, onDark: true),
        const SizedBox(height: 16),
        _RailButton(
          icon: Icons.call_split_rounded,
          label: compactNumber(context, creation.forksCount),
          tooltip: l10n.actionEvolve,
          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.editor,
            arguments: EditorArgs(parent: creation),
          ),
        ),
        const SizedBox(height: 16),
        _RailButton(
          icon: Icons.account_tree_outlined,
          label: compactNumber(context, creation.descendantsCount),
          tooltip: l10n.tabLineage,
          onTap: () => _openDetail(context, creation, heroTag: heroTag, tab: 2),
        ),
        const SizedBox(height: 16),
        _RailButton(
          icon: Icons.open_in_full_rounded,
          label: l10n.actionOpen,
          tooltip: l10n.actionOpen,
          onTap: () => _openDetail(context, creation, heroTag: heroTag),
        ),
      ],
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkResponse(
      onTap: onTap,
      radius: 28,
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
                shadows: _textShadow,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.figures(color: Colors.white)
                  .copyWith(shadows: _textShadow),
            ),
          ],
        ),
      ),
    ),
  );
}

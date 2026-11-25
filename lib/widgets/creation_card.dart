import 'package:material_ui/material_ui.dart';

import '../core/category_ui.dart';
import '../core/l10n_ext.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/feedback.dart';
import '../models/creation.dart';
import 'creation_cover.dart';
import 'lineage_chip.dart';

/// List tile for a creation: thumbnail, title, lineage and stats.
class CreationCard extends StatelessWidget {
  const CreationCard({
    super.key,
    required this.creation,
    required this.heroPrefix,
  });

  final Creation creation;

  /// Makes Hero tags unique per screen (the same creation can appear twice).
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final heroTag = '$heroPrefix-${creation.id}';

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          AppRoutes.creationDetail,
          arguments: CreationDetailArgs(
            creationId: creation.id,
            initial: creation,
            heroTag: heroTag,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: '$heroTag-cover',
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: CreationCover(
                    creation: creation,
                    compact: true,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: heroTag,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          creation.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${creation.category.label(l10n)} · '
                      '${shortDate(context, creation.createdAt)}',
                      style: text.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    LineageChip(creation: creation),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 16,
                      children: [
                        _Stat(
                          Icons.favorite_border_rounded,
                          creation.likesCount,
                          l10n.statLikes,
                        ),
                        _Stat(
                          Icons.call_split_rounded,
                          creation.forksCount,
                          l10n.statEvolutions,
                        ),
                        _Stat(
                          Icons.account_tree_outlined,
                          creation.descendantsCount,
                          l10n.statDescendants,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.value, this.tooltip);

  final IconData icon;
  final int value;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Tooltip(
      message: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            compactNumber(context, value),
            style: AppTheme.figures(color: color),
          ),
        ],
      ),
    );
  }
}

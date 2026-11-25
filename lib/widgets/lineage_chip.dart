import 'package:material_ui/material_ui.dart';

import '../core/l10n_ext.dart';
import '../core/routing/app_routes.dart';
import '../models/creation.dart';
import 'branch_glyph.dart';

/// "Original · Gen 1" or "Branch of `parent` by `author` · Gen N", led by
/// a lineage glyph (a root node, or a branch leaving its trunk).
/// Tapping a branch line opens the parent creation.
class LineageChip extends StatelessWidget {
  const LineageChip({super.key, required this.creation, this.onDark = false});

  final Creation creation;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final fg = onDark ? Colors.white70 : scheme.onSurfaceVariant;

    final text = creation.isOriginal
        ? l10n.lineageOriginal(creation.generation)
        : l10n.lineageBranchOf(
            creation.parentTitle ?? '?',
            creation.parentAuthorName ?? '?',
            creation.generation,
          );

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      onTap: creation.isOriginal
          ? null
          : () => Navigator.of(context).pushNamed(
              AppRoutes.creationDetail,
              arguments: CreationDetailArgs(
                creationId: creation.parentId!,
                initialTab: 2,
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: creation.isOriginal
                  ? SizedBox.square(
                      dimension: 16,
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: fg, width: 2),
                          ),
                          child: const SizedBox.square(dimension: 8),
                        ),
                      ),
                    )
                  : BranchGlyph(color: fg),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: fg, fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

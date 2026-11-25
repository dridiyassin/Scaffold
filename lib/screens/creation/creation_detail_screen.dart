import 'package:flutter/services.dart';
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
import '../../widgets/state_views.dart';
import '../../widgets/user_avatar.dart';

/// Full view of a creation with tabs: live preview, source code, lineage.
class CreationDetailScreen extends StatefulWidget {
  const CreationDetailScreen({super.key, required this.args});

  final CreationDetailArgs args;

  @override
  State<CreationDetailScreen> createState() => _CreationDetailScreenState();
}

class _CreationDetailScreenState extends State<CreationDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.args.initialTab.clamp(0, 2),
  );
  late final Stream<Creation?> _creation;

  String get _heroTag =>
      widget.args.heroTag ?? 'detail-${widget.args.creationId}';

  @override
  void initState() {
    super.initState();
    final service = context.read<CreationService>();
    _creation = service.watch(widget.args.creationId);
    service.registerView(widget.args.creationId);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StreamBuilder<Creation?>(
      stream: _creation,
      initialData: widget.args.initial,
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(message: describeError(l10n, snap.error!)),
          );
        }
        final creation = snap.data;
        if (creation == null) {
          return Scaffold(
            appBar: AppBar(),
            body: snap.connectionState == ConnectionState.waiting
                ? const LoadingView()
                : EmptyView(
                    icon: Icons.search_off_rounded,
                    title: l10n.creationNotFound,
                  ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Hero(
              tag: _heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  creation.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              _Header(creation: creation, heroTag: _heroTag),
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: l10n.tabPreview),
                  Tab(text: l10n.tabCode),
                  Tab(text: l10n.tabLineage),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  // Swipes go to the running creation, not the tabs.
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ColoredBox(
                      color: AppTheme.feedBackground,
                      child: CreationPreview(
                        code: creation.code,
                        captureAllGestures: true,
                      ),
                    ),
                    _CodeView(code: creation.code),
                    _LineageView(creation: creation),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.creation, required this.heroTag});

  final Creation creation;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: '$heroTag-cover',
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CreationCover(
                    creation: creation,
                    compact: true,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.userProfile,
                    arguments: UserProfileArgs(creation.authorId),
                  ),
                  child: Row(
                    children: [
                      UserAvatar(
                        name: creation.authorName,
                        photoUrl: creation.authorPhotoUrl,
                        radius: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creation.authorName,
                              style: text.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${creation.category.label(l10n)} · '
                              '${shortDate(context, creation.createdAt)}',
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LikeButton(creation: creation, vertical: false),
            ],
          ),
          if (creation.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              creation.description,
              textDirection: contentDirection(creation.description),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: LineageChip(creation: creation),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.editor,
                      arguments: EditorArgs(parent: creation),
                    ),
                icon: const Icon(Icons.call_split_rounded, size: 18),
                label: Text(l10n.actionEvolve),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.creationStats(
              creation.viewsCount,
              creation.forksCount,
              creation.descendantsCount,
            ),
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Read-only source code with line numbers (always left-to-right).
class _CodeView extends StatelessWidget {
  const _CodeView({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final lines = code.split('\n');
    // Bundled IBM Plex Mono: the same face on Android, iOS and the web.
    final style = AppTheme.code(color: scheme.onSurface).copyWith(height: 1.6);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: scheme.surfaceContainer,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        [for (var i = 1; i <= lines.length; i++) '$i']
                            .join('\n'),
                        textAlign: TextAlign.right,
                        style: style.copyWith(color: scheme.outline),
                      ),
                      const SizedBox(width: 16),
                      SelectableText(code, style: style),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton.small(
              heroTag: null,
              tooltip: l10n.actionCopyCode,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (context.mounted) showAppSnack(context, l10n.codeCopied);
              },
              child: const Icon(Icons.copy_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ancestors (root → parent → this) and direct evolutions of a creation.
class _LineageView extends StatefulWidget {
  const _LineageView({required this.creation});

  final Creation creation;

  @override
  State<_LineageView> createState() => _LineageViewState();
}

class _LineageViewState extends State<_LineageView> {
  late Future<List<Creation>> _ancestors;
  late Stream<List<Creation>> _evolutions;
  late String _loadedFor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_LineageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.creation.id != _loadedFor) _load();
  }

  void _load() {
    final service = context.read<CreationService>();
    _loadedFor = widget.creation.id;
    _ancestors = service.fetchAncestors(widget.creation);
    _evolutions = service.evolutionsOf(widget.creation.id);
  }

  void _open(Creation c) => Navigator.of(context).pushNamed(
    AppRoutes.creationDetail,
    arguments: CreationDetailArgs(creationId: c.id, initial: c, initialTab: 2),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final creation = widget.creation;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Text(l10n.lineageAncestorsTitle, style: text.titleMedium),
        const SizedBox(height: 8),
        if (creation.isOriginal)
          _TimelineTile(
            title: creation.title,
            subtitle: l10n.lineageIsOriginal,
            generation: 1,
            highlighted: true,
            isFirst: true,
            isLast: true,
          )
        else
          FutureBuilder<List<Creation>>(
            future: _ancestors,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Text(describeError(l10n, snap.error!));
              }
              final ancestors = snap.data!;
              return Column(
                children: [
                  for (final (i, a) in ancestors.indexed)
                    _TimelineTile(
                      isFirst: i == 0,
                      title: a.title,
                      subtitle: l10n.byAuthor(a.authorName),
                      generation: a.generation,
                      onTap: () => _open(a),
                    ),
                  _TimelineTile(
                    title: creation.title,
                    subtitle: l10n.lineageYouAreHere,
                    generation: creation.generation,
                    highlighted: true,
                    isLast: true,
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 32),
        StreamBuilder<List<Creation>>(
          stream: _evolutions,
          builder: (context, snap) {
            final items = snap.data ?? const <Creation>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lineageEvolutionsTitle(items.length),
                  style: text.titleMedium,
                ),
                const SizedBox(height: 8),
                if (snap.hasError)
                  Text(describeError(l10n, snap.error!))
                else if (!snap.hasData)
                  const LinearProgressIndicator()
                else if (items.isEmpty)
                  Text(l10n.lineageNoEvolutions, style: text.bodyMedium)
                else
                  for (final e in items)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: CreationCover(
                            creation: e,
                            compact: true,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: Text(e.title),
                        subtitle: Text(l10n.byAuthor(e.authorName)),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                        ),
                        onTap: () => _open(e),
                      ),
                    ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(
            AppRoutes.tree,
            arguments: TreeArgs(rootId: creation.rootId, focusId: creation.id),
          ),
          icon: const Icon(Icons.account_tree_outlined),
          label: Text(l10n.actionViewTree),
        ),
      ],
    );
  }
}

/// One node of the vertical lineage timeline.
class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.generation,
    this.highlighted = false,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final int generation;
  final bool highlighted;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                    child: isFirst
                        ? null
                        : Container(width: 2, color: scheme.outlineVariant),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: AppTheme.ease,
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: highlighted ? scheme.primary : scheme.surface,
                      border: Border.all(
                        color: highlighted ? scheme.primary : scheme.outline,
                        width: 2,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: scheme.outlineVariant),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: highlighted
                            ? AppTheme.accentText(context)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${context.l10n.generationLabel(generation)} · $subtitle',
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

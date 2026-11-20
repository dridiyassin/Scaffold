import '../l10n/app_localizations.dart';

/// How many points each engagement event is worth.
///
/// Points are applied client-side in the same batch/transaction as the action
/// (see `CreationService`). In production this should move to Cloud Functions
/// so clients cannot forge scores.
abstract final class PointsRules {
  /// Publishing any creation (original or evolution).
  static const publish = 5;

  /// Someone else likes one of your creations.
  static const likeReceived = 2;

  /// Someone evolves (forks) your creation directly.
  static const directEvolution = 10;

  /// Someone evolves a descendant of your creation (success of descendants).
  static const ancestorEvolution = 3;
}

/// Creator levels unlocked with points.
enum CreatorLevel {
  seed(0),
  sprout(50),
  sapling(200),
  tree(750),
  forest(2500);

  const CreatorLevel(this.minPoints);

  final int minPoints;

  static CreatorLevel forPoints(int points) =>
      values.lastWhere((l) => points >= l.minPoints);

  CreatorLevel? get next =>
      index + 1 < values.length ? values[index + 1] : null;

  /// Progress (0..1) from this level to the next one.
  double progress(int points) {
    final n = next;
    if (n == null) return 1;
    return ((points - minPoints) / (n.minPoints - minPoints)).clamp(0.0, 1.0);
  }

  String label(AppLocalizations l) => switch (this) {
    CreatorLevel.seed => l.levelSeed,
    CreatorLevel.sprout => l.levelSprout,
    CreatorLevel.sapling => l.levelSapling,
    CreatorLevel.tree => l.levelTree,
    CreatorLevel.forest => l.levelForest,
  };
}

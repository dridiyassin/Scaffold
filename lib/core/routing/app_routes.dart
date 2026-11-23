import '../../models/creation.dart';

/// Every named route of the application.
abstract final class AppRoutes {
  // ---- Part 1 (implemented) ----
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const creationDetail = '/creation';
  static const userProfile = '/user';
  static const settings = '/settings';

  // ---- Part 2 (placeholders until implemented) ----
  static const editor = '/editor';
  static const tree = '/tree';
  static const explore = '/explore';
  static const notifications = '/notifications';
  static const leaderboard = '/leaderboard';
  static const editProfile = '/edit-profile';
  static const premium = '/premium';
}

/// Arguments for [AppRoutes.creationDetail].
class CreationDetailArgs {
  const CreationDetailArgs({
    required this.creationId,
    this.initial,
    this.heroTag,
    this.initialTab = 0,
  });

  final String creationId;

  /// Already-loaded data, shown instantly while the live document loads.
  final Creation? initial;

  /// Tag of the title [Hero] on the previous screen.
  final String? heroTag;

  /// 0 = preview, 1 = code, 2 = lineage.
  final int initialTab;
}

/// Arguments for [AppRoutes.userProfile].
class UserProfileArgs {
  const UserProfileArgs(this.userId);

  final String userId;
}

/// Arguments for [AppRoutes.editor] (Part 2).
///
/// `parent == null` creates an original, otherwise an evolution of `parent`.
class EditorArgs {
  const EditorArgs({this.parent});

  final Creation? parent;
}

/// Arguments for [AppRoutes.tree] (Part 2).
class TreeArgs {
  const TreeArgs({required this.rootId, this.focusId});

  final String rootId;
  final String? focusId;
}

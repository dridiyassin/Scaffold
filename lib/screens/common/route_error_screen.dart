import 'package:material_ui/material_ui.dart';

import '../../core/l10n_ext.dart';
import '../../widgets/state_views.dart';

/// Shown for unknown route names or missing/invalid route arguments.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: EmptyView(
      icon: Icons.wrong_location_rounded,
      title: context.l10n.routeNotFound,
      message: routeName,
    ),
  );
}

import 'package:material_ui/material_ui.dart';

import '../core/theme/app_theme.dart';

/// The Scaffold app icon: three stacked layers inside a scaffold frame, with
/// a play button cut out of the top layer. Same geometry as
/// `brand/scaffold-icon.svg`, drawn here so it stays sharp at any size.
class AppIcon extends StatelessWidget {
  const AppIcon({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Scaffold',
    image: true,
    child: CustomPaint(size: Size.square(size), painter: const _IconPainter()),
  );
}

/// Icon + product name, used on the sign-in screens.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 32, this.heroTag});

  /// Size of the icon; the name is sized to match.
  final double size;

  /// Lets the icon fly between the splash and the sign-in screens.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget icon = AppIcon(size: size);
    if (heroTag != null) icon = Hero(tag: heroTag!, child: icon);
    return Row(
      mainAxisSize: MainAxisSize.min,
      // A logo keeps its reading order in Arabic too.
      textDirection: TextDirection.ltr,
      children: [
        icon,
        SizedBox(width: size * 0.33),
        ExcludeSemantics(
          child: Text(
            'Scaffold',
            style: TextStyle(
              fontSize: size * 0.62,
              fontWeight: FontWeight.w600,
              height: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconPainter extends CustomPainter {
  const _IconPainter();

  // Coordinates on the 1024 canvas of brand/scaffold-icon.svg.
  static const _top = [
    Offset(340, 408),
    Offset(512, 322),
    Offset(684, 408),
    Offset(512, 494),
  ];
  static const _mid = [Offset(340, 512), Offset(512, 598), Offset(684, 512)];
  static const _low = [Offset(340, 616), Offset(512, 702), Offset(684, 616)];
  static const _left = [
    Offset(408, 309),
    Offset(262, 382),
    Offset(262, 642),
    Offset(376, 699),
  ];
  static const _right = [
    Offset(616, 309),
    Offset(762, 382),
    Offset(762, 642),
    Offset(648, 699),
  ];
  static const _play = [
    Offset(492.8, 353),
    Offset(492.8, 463),
    Offset(556, 408),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    Path line(List<Offset> points, {bool closed = false}) =>
        Path()..addPolygon(points, closed);

    final s = size.shortestSide / 1024;
    canvas
      ..save()
      ..scale(s)
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(0, 0, 1024, 1024),
          const Radius.circular(232),
        ),
        Paint()..color = AppTheme.ink,
      )
      // The mark sits at 114 % of its drawn size, centred on the tile.
      ..translate(512, 512)
      ..scale(1.14)
      ..translate(-512, -512);

    final frame = stroke(AppTheme.brand, 40);
    final layer = stroke(Colors.white, 42);
    final top = line(_top, closed: true);
    final play = line(_play, closed: true);
    canvas
      ..drawPath(line(_left), frame)
      ..drawPath(line(_right), frame)
      ..drawPath(line(_low), layer)
      ..drawPath(line(_mid), layer)
      ..drawPath(top, Paint()..color = Colors.white)
      ..drawPath(top, layer)
      ..drawPath(play, Paint()..color = AppTheme.ink)
      ..drawPath(play, stroke(AppTheme.ink, 18))
      ..restore();
  }

  @override
  bool shouldRepaint(_IconPainter oldDelegate) => false;
}

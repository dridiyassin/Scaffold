import 'package:material_ui/material_ui.dart';

/// A trunk with one branch leaving it: marks every "Branch of …" line.
class BranchGlyph extends StatelessWidget {
  const BranchGlyph({super.key, this.size = 16, this.color});

  final double size;

  /// Defaults to the current icon colour.
  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _BranchPainter(color ?? IconTheme.of(context).color!),
  );
}

class _BranchPainter extends CustomPainter {
  const _BranchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;
    final node = Paint()..color = color;

    canvas
      // Trunk between the first and the latest version.
      ..drawLine(Offset(7 * s, 7 * s), Offset(7 * s, 17 * s), line)
      // The branch leaving the trunk.
      ..drawPath(
        Path()
          ..moveTo(7 * s, 16 * s)
          ..cubicTo(7 * s, 11 * s, 17 * s, 13 * s, 17 * s, 8 * s),
        line,
      )
      ..drawCircle(Offset(7 * s, 5 * s), 2.5 * s, node)
      ..drawCircle(Offset(7 * s, 19 * s), 2.5 * s, node)
      ..drawCircle(Offset(17 * s, 6 * s), 2.5 * s, node);
  }

  @override
  bool shouldRepaint(_BranchPainter oldDelegate) => oldDelegate.color != color;
}

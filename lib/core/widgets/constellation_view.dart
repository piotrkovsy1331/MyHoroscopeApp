import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/motion.dart';

/// Star positions (normalised 0..1, y grows downward) and the lines that
/// connect them.
class ConstellationShape {
  const ConstellationShape({required this.stars, required this.lines});

  final List<Offset> stars;

  /// Pairs of indexes into [stars], drawn in order.
  final List<(int, int)> lines;
}

/// Draws a constellation line by line, then lets its stars glow.
/// Shown fully drawn immediately when reduced motion is enabled.
class ConstellationView extends StatefulWidget {
  const ConstellationView({
    required this.shape,
    super.key,
    this.duration = const Duration(milliseconds: 1800),
    this.color = AppColors.goldLight,
  });

  final ConstellationShape shape;
  final Duration duration;
  final Color color;

  @override
  State<ConstellationView> createState() => _ConstellationViewState();
}

class _ConstellationViewState extends State<ConstellationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller.value = 1;
    } else if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _ConstellationPainter(
          shape: widget.shape,
          progress: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
          color: widget.color,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  _ConstellationPainter({
    required this.shape,
    required this.progress,
    required this.color,
  }) : super(repaint: progress);

  final ConstellationShape shape;
  final Animation<double> progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);
    Offset toCanvas(Offset p) => origin + Offset(p.dx * side, p.dy * side);

    final p = progress.value;
    final lineCount = shape.lines.length;
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Lines are revealed one after another over the first 80% of progress.
    final drawn = (p / 0.8).clamp(0.0, 1.0) * lineCount;
    for (var i = 0; i < lineCount; i++) {
      final local = (drawn - i).clamp(0.0, 1.0);
      if (local == 0) break;
      final (a, b) = shape.lines[i];
      final start = toCanvas(shape.stars[a]);
      final end = toCanvas(shape.stars[b]);
      canvas.drawLine(start, Offset.lerp(start, end, local)!, linePaint);
    }

    // Stars fade in early and gain a halo at the end.
    final starOpacity = (p / 0.3).clamp(0.0, 1.0);
    final glow = ((p - 0.8) / 0.2).clamp(0.0, 1.0);
    final starPaint = Paint()..color = color.withValues(alpha: starOpacity);
    final haloPaint = Paint()..color = color.withValues(alpha: 0.18 * glow);
    final starRadius = (side / 90).clamp(1.8, 4.0);
    for (final star in shape.stars) {
      final c = toCanvas(star);
      if (glow > 0) canvas.drawCircle(c, starRadius * 3, haloPaint);
      canvas.drawCircle(c, starRadius, starPaint);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.color != color;
}

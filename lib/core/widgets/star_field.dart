import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/motion.dart';

/// Softly twinkling, slowly drifting star field.
///
/// Performance: one [AnimationController] drives a [CustomPainter] through
/// its `repaint` listenable (no widget rebuilds), stars are generated once,
/// and the layer is isolated with a [RepaintBoundary]. With reduced motion
/// enabled the sky is rendered as a still frame.
class StarField extends StatefulWidget {
  const StarField({super.key, this.starCount = 140, this.seed = 7});

  final int starCount;
  final int seed;

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  /// Every periodic effect completes an integer number of cycles in this
  /// period, so the animation loops seamlessly.
  static const _period = Duration(minutes: 3);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
  );
  late final List<_Star> _stars = _generate(widget.starCount, widget.seed);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller
        ..stop()
        ..value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
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
        painter: _StarFieldPainter(_stars, _controller),
        size: Size.infinite,
      ),
    );
  }

  static List<_Star> _generate(int count, int seed) {
    final random = math.Random(seed);
    return List.generate(count, (i) {
      final bright = i % 23 == 0;
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: bright ? 1.6 : 0.4 + random.nextDouble() * 1.0,
        baseOpacity: 0.35 + random.nextDouble() * 0.5,
        twinkleCycles: 20 + random.nextInt(40),
        phase: random.nextDouble(),
        // Only the nearer ~third of stars drifts, giving a parallax feel.
        driftCycles: random.nextDouble() < 0.35 ? 1 : 0,
        bright: bright,
        golden: random.nextDouble() < 0.12,
      );
    });
  }
}

class _Star {
  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.baseOpacity,
    required this.twinkleCycles,
    required this.phase,
    required this.driftCycles,
    required this.bright,
    required this.golden,
  });

  final double x;
  final double y;
  final double radius;
  final double baseOpacity;
  final int twinkleCycles;
  final double phase;
  final int driftCycles;
  final bool bright;
  final bool golden;
}

class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter(this.stars, this.animation) : super(repaint: animation);

  final List<_Star> stars;
  final Animation<double> animation;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    for (final star in stars) {
      final twinkle =
          0.5 +
          0.5 * math.sin(2 * math.pi * (t * star.twinkleCycles + star.phase));
      final opacity = (star.baseOpacity * (0.55 + 0.45 * twinkle)).clamp(
        0.0,
        1.0,
      );
      final dy = (star.y + t * star.driftCycles) % 1.0;
      final center = Offset(star.x * size.width, dy * size.height);
      final color = star.golden ? AppColors.goldLight : Colors.white;

      _paint
        ..color = color.withValues(alpha: opacity)
        ..strokeWidth = 0.6;
      canvas.drawCircle(center, star.radius, _paint);

      if (star.bright) {
        // Thin four-point sparkle instead of an expensive blur.
        final arm = 4 + 3 * twinkle;
        _paint.color = color.withValues(alpha: opacity * 0.6);
        canvas
          ..drawLine(
            center.translate(-arm, 0),
            center.translate(arm, 0),
            _paint,
          )
          ..drawLine(
            center.translate(0, -arm),
            center.translate(0, arm),
            _paint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) =>
      oldDelegate.stars != stars;
}

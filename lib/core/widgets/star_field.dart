import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/motion.dart';

/// Softly twinkling, slowly drifting star field.
///
/// Performance:
/// - Repaints at most [frameInterval] (30 fps) instead of every vsync: the
///   twinkle cycles last seconds, so 30 fps looks identical while a 120 Hz
///   screen does a quarter of the work when the app is otherwise idle.
/// - A periodic timer (not a Ticker) drives the painter's `repaint`
///   listenable, so no frames are scheduled in between and no widgets
///   rebuild; the timer stops while the app is not in the foreground.
/// - Stars are generated once; the layer is isolated by a [RepaintBoundary].
/// - With reduced motion enabled the sky is a single still frame.
class StarField extends StatefulWidget {
  const StarField({super.key, this.starCount = 140, this.seed = 7});

  final int starCount;
  final int seed;

  static const frameInterval = Duration(milliseconds: 33);

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField> with WidgetsBindingObserver {
  /// Every periodic effect completes an integer number of cycles in this
  /// period, so the animation loops seamlessly.
  static const _period = Duration(minutes: 3);
  static const _stillPhase = 0.25;

  /// Position within [_period], 0..1.
  final ValueNotifier<double> _phase = ValueNotifier(_stillPhase);
  final Stopwatch _clock = Stopwatch();
  late final List<_Star> _stars = _generate(widget.starCount, widget.seed);
  Timer? _timer;
  bool _reduceMotion = false;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = reduceMotionOf(context);
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  void _sync() {
    if (_reduceMotion || !_foreground) {
      _timer?.cancel();
      _timer = null;
      _clock.stop();
      if (_reduceMotion) _phase.value = _stillPhase;
    } else if (_timer == null) {
      _clock.start();
      _timer = Timer.periodic(StarField.frameInterval, (_) {
        final elapsed = _clock.elapsedMicroseconds / _period.inMicroseconds;
        _phase.value = (_stillPhase + elapsed) % 1.0;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _StarFieldPainter(_stars, _phase),
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
  _StarFieldPainter(this.stars, this.phase) : super(repaint: phase);

  final List<_Star> stars;
  final ValueListenable<double> phase;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final t = phase.value;
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

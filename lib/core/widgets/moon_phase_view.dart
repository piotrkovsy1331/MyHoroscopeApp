import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/moon_phase.dart';

/// Draws the Moon's disc with the lit part for the given [phase]
/// (northern-hemisphere orientation: waxing is lit on the right).
class MoonPhaseView extends StatelessWidget {
  const MoonPhaseView({required this.phase, super.key, this.size = 72});

  final MoonPhase phase;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MoonPainter(phase.fraction)),
    );
  }
}

class _MoonPainter extends CustomPainter {
  const _MoonPainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 * 0.82;
    final c = size.center(Offset.zero);
    final disc = Rect.fromCircle(center: c, radius: r);

    // Soft halo.
    canvas.drawCircle(
      c,
      r * 1.22,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.goldLight.withValues(alpha: 0.22),
            AppColors.goldLight.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.22)),
    );

    // Unlit disc.
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF2A2F55));

    // Lit part: half disc on the lit side plus/minus the terminator ellipse.
    // +1 at new moon, 0 at quarters, -1 at full moon.
    final k = math.cos(2 * math.pi * fraction);
    final rx = r * k.abs();
    final top = Offset(c.dx, c.dy - r);
    final bottom = Offset(c.dx, c.dy + r);
    final waxing = fraction < 0.5;
    final crescent = k > 0;

    final path = Path()..moveTo(top.dx, top.dy);
    path.arcToPoint(bottom, radius: Radius.circular(r), clockwise: waxing);
    path.arcToPoint(
      top,
      radius: Radius.elliptical(rx == 0 ? 0.001 : rx, r),
      clockwise: waxing ? !crescent : crescent,
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF6DA), AppColors.goldLight],
        ).createShader(disc),
    );

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = AppColors.goldLight.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(_MoonPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}

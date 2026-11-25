import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'star_field.dart';

/// Night-sky gradient, two faint static nebula glows and the animated
/// [StarField], painted once behind the whole app.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.skyGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _Nebula(
            alignment: Alignment(-0.9, -0.7),
            color: AppColors.deepViolet,
          ),
          const _Nebula(
            alignment: Alignment(1.1, 0.6),
            color: Color(0xFF2B1F5C),
          ),
          const ExcludeSemantics(child: StarField()),
          child,
        ],
      ),
    );
  }
}

class _Nebula extends StatelessWidget {
  const _Nebula({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: alignment,
            radius: 0.9,
            colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

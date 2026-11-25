import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Paints the night-sky gradient behind [child].
/// Animated stars are layered on top of this in the UI stage.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.skyGradient),
      child: child,
    );
  }
}

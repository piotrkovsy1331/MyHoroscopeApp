import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Translucent card with a thin gold hairline border.
///
/// Uses a semi-transparent gradient instead of `BackdropFilter` blur, which
/// would be re-rasterised every frame over the animated sky.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  static const _radius = BorderRadius.all(Radius.circular(22));

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: _radius,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceHigh.withValues(alpha: 0.78),
              AppColors.surface.withValues(alpha: 0.62),
            ],
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: onTap == null
              ? content
              : InkWell(
                  borderRadius: _radius,
                  onTap: onTap,
                  splashColor: AppColors.gold.withValues(alpha: 0.12),
                  highlightColor: AppColors.gold.withValues(alpha: 0.06),
                  child: content,
                ),
        ),
      ),
    );
  }
}

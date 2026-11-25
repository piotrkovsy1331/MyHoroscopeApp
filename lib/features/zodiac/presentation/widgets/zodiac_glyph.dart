import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/motion.dart';
import '../../domain/entities/zodiac_sign.dart';

/// The sign's astrological symbol in gold, rendered with the bundled
/// zodiac font. With [glow] it breathes with a subtle halo (static when
/// reduced motion is on).
class ZodiacGlyph extends StatefulWidget {
  const ZodiacGlyph({
    required this.sign,
    super.key,
    this.size = 40,
    this.glow = false,
  });

  final ZodiacSign sign;
  final double size;
  final bool glow;

  @override
  State<ZodiacGlyph> createState() => _ZodiacGlyphState();
}

class _ZodiacGlyphState extends State<ZodiacGlyph>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = widget.glow && !reduceMotionOf(context);
    if (animate && _controller == null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);
    } else if (!animate) {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  TextStyle _style(double glow) => TextStyle(
    fontFamily: AppFonts.zodiac,
    fontSize: widget.size,
    height: 1,
    color: AppColors.gold,
    shadows: widget.glow
        ? [
            Shadow(
              color: AppColors.goldLight.withValues(alpha: 0.35 + 0.35 * glow),
              blurRadius: widget.size * (0.25 + 0.25 * glow),
            ),
          ]
        : null,
  );

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    // Decorative: the sign's name is always shown next to the glyph.
    return ExcludeSemantics(
      child: controller == null
          ? Text(widget.sign.symbol, style: _style(0.5))
          : AnimatedBuilder(
              animation: controller,
              builder: (context, _) => Text(
                widget.sign.symbol,
                style: _style(Curves.easeInOut.transform(controller.value)),
              ),
            ),
    );
  }
}

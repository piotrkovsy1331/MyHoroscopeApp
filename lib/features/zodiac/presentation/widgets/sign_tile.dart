import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../zodiac_l10n.dart';
import 'zodiac_glyph.dart';

class SignTile extends StatelessWidget {
  const SignTile({required this.sign, required this.onTap, super.key});

  final ZodiacSign sign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final name = sign.localizedName(l10n);
    final dates = sign.localizedDateRange(l10n);

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      semanticLabel: '$name, $dates',
      child: ExcludeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'glyph-${sign.id}',
              child: ZodiacGlyph(sign: sign, size: 36),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Scales down instead of clipping on narrow tiles.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(dates, style: theme.textTheme.bodySmall, maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}

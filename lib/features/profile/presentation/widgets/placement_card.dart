import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';
import '../../domain/entities/birth_data.dart';
import '../../domain/entities/natal_chart.dart';

/// One chart point. Uncertain or missing results are worded as such.
class PlacementCard extends StatelessWidget {
  const PlacementCard({
    required this.title,
    required this.placement,
    required this.birthData,
    super.key,
  });

  final String title;
  final Placement placement;
  final BirthData birthData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final (Widget leading, String value, String? hint) = switch (placement) {
      KnownPlacement(:final sign) => (
        ZodiacGlyph(sign: sign, size: 34),
        sign.localizedName(l10n),
        null,
      ),
      AmbiguousPlacement(:final candidates) => (
        const Icon(Icons.help_outline, size: 32),
        candidates.length == 2
            ? l10n.profileOr(
                candidates[0].localizedName(l10n),
                candidates[1].localizedName(l10n),
              )
            : candidates.map((s) => s.localizedName(l10n)).join(' / '),
        birthData.time == null
            ? l10n.profileHintAddTime
            : l10n.profileHintAddPlace,
      ),
      UnavailablePlacement(:final reason) => (
        const Icon(Icons.lock_clock_outlined, size: 32),
        '—',
        switch (reason) {
          UnavailableReason.needsTimeAndPlace => l10n.profileNeedsTimeAndPlace,
          UnavailableReason.polarLatitude => l10n.profilePolar,
        },
      ),
    };

    final sign = switch (placement) {
      KnownPlacement(:final sign) => sign,
      _ => null,
    };

    return GlassCard(
      onTap: sign == null
          ? null
          : () => context.go(AppRoutes.signDetail(sign.id)),
      semanticLabel: [title, value, ?hint].join(', '),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ExcludeSemantics(
        child: Row(
          children: [
            SizedBox(width: 44, child: Center(child: leading)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(value, style: theme.textTheme.titleLarge),
                  if (hint != null) ...[
                    const SizedBox(height: 4),
                    Text(hint, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            if (sign != null) const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

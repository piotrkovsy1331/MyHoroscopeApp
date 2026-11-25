import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/constellation_view.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../constellations.dart';
import '../widgets/zodiac_glyph.dart';
import '../zodiac_l10n.dart';

class SignDetailPage extends StatelessWidget {
  const SignDetailPage({required this.sign, super.key});

  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    // Dimmed so it reads as a backdrop for the glyph.
                    child: Opacity(
                      opacity: 0.55,
                      child: ConstellationView(shape: sign.constellation),
                    ),
                  ),
                ),
                Hero(
                  tag: 'glyph-${sign.id}',
                  child: ZodiacGlyph(sign: sign, size: 64, glow: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            sign.localizedName(l10n),
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 4),
          Text(
            sign.localizedDateRange(l10n),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          // Primary action stays above the fold on small phones.
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Center(
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.horoscope(sign.id)),
                icon: const Icon(Icons.auto_awesome),
                label: Text(l10n.signDetailReadHoroscope),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            delay: const Duration(milliseconds: 150),
            child: GlassCard(
              child: Column(
                children: [
                  _AttributeRow(
                    label: l10n.signDetailElement,
                    value: sign.element.localizedName(l10n),
                  ),
                  _AttributeRow(
                    label: l10n.signDetailModality,
                    value: sign.modality.localizedName(l10n),
                  ),
                  _AttributeRow(
                    label: l10n.signDetailRuler,
                    value: sign.ruler.localizedName(l10n),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 250),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.signDetailPersonality,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sign.localizedKeywords(l10n),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    sign.localizedDescription(l10n),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttributeRow extends StatelessWidget {
  const _AttributeRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(value, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

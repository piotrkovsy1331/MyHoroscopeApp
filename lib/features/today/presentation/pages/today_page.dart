import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/moon_phase.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/moon_phase_view.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';

/// Daily dashboard. Shows only computed sky facts (Moon phase, Sun season);
/// the user's own horoscope card is added together with the profile.
class TodayPage extends StatelessWidget {
  const TodayPage({super.key, this.now});

  /// Injectable clock for tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final date = now ?? DateTime.now();
    final moon = MoonPhase.at(date);
    final sunSign = ZodiacSign.fromDate(date);

    final cards = <Widget>[
      _MoonCard(phase: moon),
      GlassCard(
        child: Row(
          children: [
            ZodiacGlyph(sign: sunSign, size: 44),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todaySunSeasonTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.todaySunSeasonBody(sunSign.localizedName(l10n)),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.todayPickSignTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(l10n.todayPickSignBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.signs),
              child: Text(l10n.todayPickSignAction),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text(
              DateFormat.yMMMMEEEEd(l10n.localeName).format(date),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(l10n.appTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 24),
            for (final (i, card) in cards.indexed) ...[
              FadeSlideIn(
                delay: Duration(milliseconds: 120 * i),
                child: card,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _MoonCard extends StatelessWidget {
  const _MoonCard({required this.phase});

  final MoonPhase phase;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        children: [
          ExcludeSemantics(child: MoonPhaseView(phase: phase)),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.todayMoonTitle, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  _phaseName(l10n, phase.name),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.todayMoonIllumination(
                    (phase.illumination * 100).round(),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _phaseName(AppLocalizations l10n, MoonPhaseName name) =>
      switch (name) {
        MoonPhaseName.newMoon => l10n.moonNew,
        MoonPhaseName.waxingCrescent => l10n.moonWaxingCrescent,
        MoonPhaseName.firstQuarter => l10n.moonFirstQuarter,
        MoonPhaseName.waxingGibbous => l10n.moonWaxingGibbous,
        MoonPhaseName.fullMoon => l10n.moonFull,
        MoonPhaseName.waningGibbous => l10n.moonWaningGibbous,
        MoonPhaseName.lastQuarter => l10n.moonLastQuarter,
        MoonPhaseName.waningCrescent => l10n.moonWaningCrescent,
      };
}

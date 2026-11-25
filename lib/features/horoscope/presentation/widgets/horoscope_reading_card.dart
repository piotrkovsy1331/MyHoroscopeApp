import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';

class HoroscopeReadingCard extends StatelessWidget {
  const HoroscopeReadingCard({required this.horoscope, super.key});

  final Horoscope horoscope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          periodLabel(l10n, horoscope).toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.gold,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        SelectableText(horoscope.text, style: theme.textTheme.bodyLarge),
      ],
    );
  }

  static String periodLabel(AppLocalizations l10n, Horoscope h) {
    final locale = l10n.localeName;
    return switch (h.period) {
      HoroscopePeriod.daily => DateFormat.MMMMEEEEd(
        locale,
      ).format(h.periodStart),
      HoroscopePeriod.weekly => l10n.horoscopeWeekOf(
        DateFormat.MMMMd(locale).format(h.periodStart),
      ),
      HoroscopePeriod.monthly => DateFormat.yMMMM(locale).format(h.periodStart),
    };
  }
}

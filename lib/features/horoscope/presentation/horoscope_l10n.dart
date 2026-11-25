import '../../../core/localization/generated/app_localizations.dart';
import '../domain/entities/horoscope_period.dart';

extension HoroscopePeriodL10n on HoroscopePeriod {
  String localizedName(AppLocalizations l10n) => switch (this) {
    HoroscopePeriod.daily => l10n.periodDaily,
    HoroscopePeriod.weekly => l10n.periodWeekly,
    HoroscopePeriod.monthly => l10n.periodMonthly,
  };
}

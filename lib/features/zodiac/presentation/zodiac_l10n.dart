import 'package:intl/intl.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../domain/entities/zodiac_sign.dart';

/// Localized labels for zodiac domain values (keeps domain l10n-free).
extension ZodiacSignL10n on ZodiacSign {
  String localizedName(AppLocalizations l10n) => switch (this) {
    ZodiacSign.aries => l10n.signAries,
    ZodiacSign.taurus => l10n.signTaurus,
    ZodiacSign.gemini => l10n.signGemini,
    ZodiacSign.cancer => l10n.signCancer,
    ZodiacSign.leo => l10n.signLeo,
    ZodiacSign.virgo => l10n.signVirgo,
    ZodiacSign.libra => l10n.signLibra,
    ZodiacSign.scorpio => l10n.signScorpio,
    ZodiacSign.sagittarius => l10n.signSagittarius,
    ZodiacSign.capricorn => l10n.signCapricorn,
    ZodiacSign.aquarius => l10n.signAquarius,
    ZodiacSign.pisces => l10n.signPisces,
  };

  /// e.g. "Mar 21 – Apr 19" in the UI locale.
  String localizedDateRange(AppLocalizations l10n) {
    final format = DateFormat.MMMd(l10n.localeName);
    // Year 2000 is only a carrier for month/day formatting.
    String fmt(MonthDay d) => format.format(DateTime(2000, d.month, d.day));
    return l10n.signDateRange(fmt(start), fmt(end));
  }
}

extension ZodiacElementL10n on ZodiacElement {
  String localizedName(AppLocalizations l10n) => switch (this) {
    ZodiacElement.fire => l10n.elementFire,
    ZodiacElement.earth => l10n.elementEarth,
    ZodiacElement.air => l10n.elementAir,
    ZodiacElement.water => l10n.elementWater,
  };
}

extension ZodiacModalityL10n on ZodiacModality {
  String localizedName(AppLocalizations l10n) => switch (this) {
    ZodiacModality.cardinal => l10n.modalityCardinal,
    ZodiacModality.fixed => l10n.modalityFixed,
    ZodiacModality.mutable => l10n.modalityMutable,
  };
}

extension RulingPlanetL10n on RulingPlanet {
  String localizedName(AppLocalizations l10n) => switch (this) {
    RulingPlanet.sun => l10n.planetSun,
    RulingPlanet.moon => l10n.planetMoon,
    RulingPlanet.mercury => l10n.planetMercury,
    RulingPlanet.venus => l10n.planetVenus,
    RulingPlanet.mars => l10n.planetMars,
    RulingPlanet.jupiter => l10n.planetJupiter,
    RulingPlanet.saturn => l10n.planetSaturn,
    RulingPlanet.uranus => l10n.planetUranus,
    RulingPlanet.neptune => l10n.planetNeptune,
    RulingPlanet.pluto => l10n.planetPluto,
  };
}

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

  String localizedKeywords(AppLocalizations l10n) => switch (this) {
    ZodiacSign.aries => l10n.signAriesKeywords,
    ZodiacSign.taurus => l10n.signTaurusKeywords,
    ZodiacSign.gemini => l10n.signGeminiKeywords,
    ZodiacSign.cancer => l10n.signCancerKeywords,
    ZodiacSign.leo => l10n.signLeoKeywords,
    ZodiacSign.virgo => l10n.signVirgoKeywords,
    ZodiacSign.libra => l10n.signLibraKeywords,
    ZodiacSign.scorpio => l10n.signScorpioKeywords,
    ZodiacSign.sagittarius => l10n.signSagittariusKeywords,
    ZodiacSign.capricorn => l10n.signCapricornKeywords,
    ZodiacSign.aquarius => l10n.signAquariusKeywords,
    ZodiacSign.pisces => l10n.signPiscesKeywords,
  };

  /// Short personality portrait (app-authored content).
  String localizedDescription(AppLocalizations l10n) => switch (this) {
    ZodiacSign.aries => l10n.signAriesDescription,
    ZodiacSign.taurus => l10n.signTaurusDescription,
    ZodiacSign.gemini => l10n.signGeminiDescription,
    ZodiacSign.cancer => l10n.signCancerDescription,
    ZodiacSign.leo => l10n.signLeoDescription,
    ZodiacSign.virgo => l10n.signVirgoDescription,
    ZodiacSign.libra => l10n.signLibraDescription,
    ZodiacSign.scorpio => l10n.signScorpioDescription,
    ZodiacSign.sagittarius => l10n.signSagittariusDescription,
    ZodiacSign.capricorn => l10n.signCapricornDescription,
    ZodiacSign.aquarius => l10n.signAquariusDescription,
    ZodiacSign.pisces => l10n.signPiscesDescription,
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

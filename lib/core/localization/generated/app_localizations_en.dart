// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mystic Horoscope';

  @override
  String get splashTagline => 'Your guide to the stars';

  @override
  String get navToday => 'Today';

  @override
  String get navSigns => 'Signs';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navProfile => 'Profile';

  @override
  String get todayMoonTitle => 'The Moon today';

  @override
  String todayMoonIllumination(int percent) {
    return '$percent% illuminated';
  }

  @override
  String get todaySunSeasonTitle => 'Sun season';

  @override
  String todaySunSeasonBody(String sign) {
    return 'The Sun is travelling through $sign.';
  }

  @override
  String get todayPickSignTitle => 'Find your sign';

  @override
  String get todayPickSignBody =>
      'Choose your zodiac sign to read its daily, weekly and monthly horoscope.';

  @override
  String get todayPickSignAction => 'Browse signs';

  @override
  String get moonNew => 'New Moon';

  @override
  String get moonWaxingCrescent => 'Waxing Crescent';

  @override
  String get moonFirstQuarter => 'First Quarter';

  @override
  String get moonWaxingGibbous => 'Waxing Gibbous';

  @override
  String get moonFull => 'Full Moon';

  @override
  String get moonWaningGibbous => 'Waning Gibbous';

  @override
  String get moonLastQuarter => 'Last Quarter';

  @override
  String get moonWaningCrescent => 'Waning Crescent';

  @override
  String get signsTitle => 'Zodiac signs';

  @override
  String get signAries => 'Aries';

  @override
  String get signTaurus => 'Taurus';

  @override
  String get signGemini => 'Gemini';

  @override
  String get signCancer => 'Cancer';

  @override
  String get signLeo => 'Leo';

  @override
  String get signVirgo => 'Virgo';

  @override
  String get signLibra => 'Libra';

  @override
  String get signScorpio => 'Scorpio';

  @override
  String get signSagittarius => 'Sagittarius';

  @override
  String get signCapricorn => 'Capricorn';

  @override
  String get signAquarius => 'Aquarius';

  @override
  String get signPisces => 'Pisces';

  @override
  String signDateRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get elementFire => 'Fire';

  @override
  String get elementEarth => 'Earth';

  @override
  String get elementAir => 'Air';

  @override
  String get elementWater => 'Water';

  @override
  String get modalityCardinal => 'Cardinal';

  @override
  String get modalityFixed => 'Fixed';

  @override
  String get modalityMutable => 'Mutable';

  @override
  String get planetSun => 'Sun';

  @override
  String get planetMoon => 'Moon';

  @override
  String get planetMercury => 'Mercury';

  @override
  String get planetVenus => 'Venus';

  @override
  String get planetMars => 'Mars';

  @override
  String get planetJupiter => 'Jupiter';

  @override
  String get planetSaturn => 'Saturn';

  @override
  String get planetUranus => 'Uranus';

  @override
  String get planetNeptune => 'Neptune';

  @override
  String get planetPluto => 'Pluto';

  @override
  String get signDetailElement => 'Element';

  @override
  String get signDetailModality => 'Modality';

  @override
  String get signDetailRuler => 'Ruling planet';

  @override
  String get signDetailDates => 'Dates';

  @override
  String get signDetailReadHoroscope => 'Read horoscope';

  @override
  String get signDetailPersonality => 'Personality';

  @override
  String get signAriesKeywords => 'Courageous · Energetic · Direct';

  @override
  String get signAriesDescription =>
      'The first sign of the zodiac, Aries charges ahead with the spark of new beginnings. Ruled by Mars, it is bold, competitive and quick to act, at its best when leading the way or taking on a challenge. Patience is its lifelong lesson.';

  @override
  String get signTaurusKeywords => 'Steady · Sensual · Loyal';

  @override
  String get signTaurusDescription =>
      'Taurus values comfort, beauty and things that last. Ruled by Venus, it moves at its own unhurried pace, building security through patience and persistence. Dependable and devoted, it can also be wonderfully stubborn.';

  @override
  String get signGeminiKeywords => 'Curious · Witty · Adaptable';

  @override
  String get signGeminiDescription =>
      'Gemini lives for ideas, conversation and variety. Ruled by Mercury, it learns fast, connects people and sees every side of a story. Its restless mind thrives on novelty, though focus can be a challenge.';

  @override
  String get signCancerKeywords => 'Caring · Intuitive · Protective';

  @override
  String get signCancerDescription =>
      'Cancer is the zodiac\'s nurturer, guided by the Moon and deep feeling. It treasures home, family and memories, and protects loved ones fiercely. Beneath its sensitive shell lies remarkable emotional strength.';

  @override
  String get signLeoKeywords => 'Warm · Generous · Expressive';

  @override
  String get signLeoDescription =>
      'Ruled by the Sun, Leo shines with warmth, creativity and confidence. It loves to celebrate, to perform and to lift others up with big-hearted loyalty. Recognition fuels it, and pride can be its blind spot.';

  @override
  String get signVirgoKeywords => 'Thoughtful · Precise · Helpful';

  @override
  String get signVirgoDescription =>
      'Virgo notices the details others miss. Ruled by Mercury, it brings clear thinking, practical skill and a genuine wish to be useful. It strives for improvement in everything, and learning to be gentle with itself matters.';

  @override
  String get signLibraKeywords => 'Harmonious · Charming · Fair';

  @override
  String get signLibraDescription =>
      'Libra seeks balance, beauty and fairness in every relationship. Ruled by Venus, it is diplomatic, sociable and gifted at seeing both sides. Decisions can take time, because it wants the outcome to feel right for everyone.';

  @override
  String get signScorpioKeywords => 'Intense · Loyal · Perceptive';

  @override
  String get signScorpioDescription =>
      'Scorpio feels everything deeply and sees beneath the surface. Associated with Pluto and Mars, it is magnetic, determined and fiercely loyal. It values trust above all, and its power lies in transformation.';

  @override
  String get signSagittariusKeywords =>
      'Adventurous · Optimistic · Free-spirited';

  @override
  String get signSagittariusDescription =>
      'Sagittarius is the zodiac\'s explorer, always seeking the next horizon. Ruled by Jupiter, it is enthusiastic, philosophical and honest to the point of bluntness. Freedom and meaning keep its fire burning.';

  @override
  String get signCapricornKeywords => 'Ambitious · Disciplined · Responsible';

  @override
  String get signCapricornDescription =>
      'Capricorn climbs steadily toward its goals. Ruled by Saturn, it is practical, patient and serious about its commitments, with a dry sense of humour. Success is built step by step, and rest must be earned and learned.';

  @override
  String get signAquariusKeywords => 'Original · Independent · Humanitarian';

  @override
  String get signAquariusDescription =>
      'Aquarius thinks ahead of its time. Associated with Uranus and Saturn, it is inventive, principled and devoted to friends and causes. It prizes independence and may seem detached, yet it cares about the bigger picture.';

  @override
  String get signPiscesKeywords => 'Imaginative · Compassionate · Dreamy';

  @override
  String get signPiscesDescription =>
      'The final sign, Pisces flows between reality and imagination. Associated with Neptune and Jupiter, it is empathetic, artistic and deeply intuitive. It absorbs the feelings around it, so healthy boundaries help it thrive.';

  @override
  String horoscopeTitle(String sign) {
    return '$sign horoscope';
  }

  @override
  String get periodDaily => 'Today';

  @override
  String get periodWeekly => 'This week';

  @override
  String get periodMonthly => 'This month';

  @override
  String get horoscopeLoading => 'Reading the stars…';

  @override
  String horoscopeWeekOf(String date) {
    return 'Week of $date';
  }

  @override
  String horoscopeStaleNotice(String date) {
    return 'You\'re offline — showing the reading saved on $date.';
  }

  @override
  String get horoscopeAttribution => 'Powered by FreeHoroscopeAPI';

  @override
  String get errorNetwork =>
      'You seem to be offline. Check your connection and try again.';

  @override
  String get errorServer =>
      'The stars are hidden right now. Please try again in a moment.';

  @override
  String get errorDataFormat =>
      'We received an unexpected answer from the horoscope service.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get actionRetry => 'Try again';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyBody =>
      'Tap the heart on a horoscope to keep it here.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEmptyTitle => 'Your astrological profile';

  @override
  String get profileEmptyBody =>
      'Add your birth details to discover your Sun, Moon and Rising signs.';

  @override
  String get profileLicenses => 'Open-source licenses';

  @override
  String get profileAddDetails => 'Add birth details';

  @override
  String get profilePrivacyNote =>
      'Your birth details are stored only on this device.';

  @override
  String get profileChartTitle => 'Your chart';

  @override
  String get profileSun => 'Sun sign';

  @override
  String get profileMoon => 'Moon sign';

  @override
  String get profileRising => 'Rising sign';

  @override
  String profileOr(String first, String second) {
    return '$first or $second';
  }

  @override
  String get profileHintAddTime => 'Add your birth time to pin this down.';

  @override
  String get profileHintAddPlace => 'Add your birthplace to pin this down.';

  @override
  String get profileNeedsTimeAndPlace =>
      'Needs your birth time and birthplace.';

  @override
  String get profilePolar => 'Not defined this close to the poles.';

  @override
  String get profileDetailsTitle => 'Birth details';

  @override
  String get profileTimeUnknown => 'Time unknown';

  @override
  String get profilePlaceUnknown => 'Place unknown';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileRemove => 'Remove profile';

  @override
  String get profileRemoveConfirmTitle => 'Remove your profile?';

  @override
  String get profileRemoveConfirmBody =>
      'Your birth details will be deleted from this device.';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRemove => 'Remove';

  @override
  String get profileReadMyHoroscope => 'Read my horoscope';

  @override
  String get todayYourSignTitle => 'Your sign';

  @override
  String get todayYourSignAction => 'Read today\'s horoscope';

  @override
  String get birthFormTitle => 'Birth details';

  @override
  String get birthFormDate => 'Date of birth';

  @override
  String get birthFormDatePlaceholder => 'Choose a date';

  @override
  String get birthFormKnowTime => 'I know my birth time';

  @override
  String get birthFormTime => 'Time of birth';

  @override
  String get birthFormTimePlaceholder => 'Choose a time';

  @override
  String get birthFormTimeHint =>
      'Needed for your Rising sign and an exact Moon sign.';

  @override
  String get birthFormPlace => 'Place of birth';

  @override
  String get birthFormPlaceHint => 'Search for a city';

  @override
  String get birthFormPlaceNoResults =>
      'No matching city. Try the nearest larger city.';

  @override
  String get birthFormPlaceClear => 'Clear place';

  @override
  String get birthFormPlaceAttribution => 'Place data © GeoNames (CC BY 4.0)';

  @override
  String get birthFormSave => 'Save';

  @override
  String get notFoundTitle => 'Lost among the stars';

  @override
  String get notFoundAction => 'Back to today';
}

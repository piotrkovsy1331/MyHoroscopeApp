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
  String get notFoundTitle => 'Lost among the stars';

  @override
  String get notFoundAction => 'Back to today';
}

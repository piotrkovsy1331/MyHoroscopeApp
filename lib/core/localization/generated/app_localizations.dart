import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name shown in headers and the OS task switcher.
  ///
  /// In en, this message translates to:
  /// **'Mystic Horoscope'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your guide to the stars'**
  String get splashTagline;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navSigns.
  ///
  /// In en, this message translates to:
  /// **'Signs'**
  String get navSigns;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @todayMoonTitle.
  ///
  /// In en, this message translates to:
  /// **'The Moon today'**
  String get todayMoonTitle;

  /// No description provided for @todayMoonIllumination.
  ///
  /// In en, this message translates to:
  /// **'{percent}% illuminated'**
  String todayMoonIllumination(int percent);

  /// No description provided for @todaySunSeasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Sun season'**
  String get todaySunSeasonTitle;

  /// No description provided for @todaySunSeasonBody.
  ///
  /// In en, this message translates to:
  /// **'The Sun is travelling through {sign}.'**
  String todaySunSeasonBody(String sign);

  /// No description provided for @todayPickSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your sign'**
  String get todayPickSignTitle;

  /// No description provided for @todayPickSignBody.
  ///
  /// In en, this message translates to:
  /// **'Choose your zodiac sign to read its daily, weekly and monthly horoscope.'**
  String get todayPickSignBody;

  /// No description provided for @todayPickSignAction.
  ///
  /// In en, this message translates to:
  /// **'Browse signs'**
  String get todayPickSignAction;

  /// No description provided for @moonNew.
  ///
  /// In en, this message translates to:
  /// **'New Moon'**
  String get moonNew;

  /// No description provided for @moonWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing Crescent'**
  String get moonWaxingCrescent;

  /// No description provided for @moonFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First Quarter'**
  String get moonFirstQuarter;

  /// No description provided for @moonWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing Gibbous'**
  String get moonWaxingGibbous;

  /// No description provided for @moonFull.
  ///
  /// In en, this message translates to:
  /// **'Full Moon'**
  String get moonFull;

  /// No description provided for @moonWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning Gibbous'**
  String get moonWaningGibbous;

  /// No description provided for @moonLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last Quarter'**
  String get moonLastQuarter;

  /// No description provided for @moonWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning Crescent'**
  String get moonWaningCrescent;

  /// No description provided for @signsTitle.
  ///
  /// In en, this message translates to:
  /// **'Zodiac signs'**
  String get signsTitle;

  /// No description provided for @signAries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get signAries;

  /// No description provided for @signTaurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get signTaurus;

  /// No description provided for @signGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get signGemini;

  /// No description provided for @signCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get signCancer;

  /// No description provided for @signLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get signLeo;

  /// No description provided for @signVirgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get signVirgo;

  /// No description provided for @signLibra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get signLibra;

  /// No description provided for @signScorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get signScorpio;

  /// No description provided for @signSagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get signSagittarius;

  /// No description provided for @signCapricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get signCapricorn;

  /// No description provided for @signAquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get signAquarius;

  /// No description provided for @signPisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get signPisces;

  /// No description provided for @signDateRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String signDateRange(String start, String end);

  /// No description provided for @elementFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get elementFire;

  /// No description provided for @elementEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get elementEarth;

  /// No description provided for @elementAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get elementAir;

  /// No description provided for @elementWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get elementWater;

  /// No description provided for @modalityCardinal.
  ///
  /// In en, this message translates to:
  /// **'Cardinal'**
  String get modalityCardinal;

  /// No description provided for @modalityFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get modalityFixed;

  /// No description provided for @modalityMutable.
  ///
  /// In en, this message translates to:
  /// **'Mutable'**
  String get modalityMutable;

  /// No description provided for @planetSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get planetSun;

  /// No description provided for @planetMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get planetMoon;

  /// No description provided for @planetMercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get planetMercury;

  /// No description provided for @planetVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get planetVenus;

  /// No description provided for @planetMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get planetMars;

  /// No description provided for @planetJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get planetJupiter;

  /// No description provided for @planetSaturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get planetSaturn;

  /// No description provided for @planetUranus.
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get planetUranus;

  /// No description provided for @planetNeptune.
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get planetNeptune;

  /// No description provided for @planetPluto.
  ///
  /// In en, this message translates to:
  /// **'Pluto'**
  String get planetPluto;

  /// No description provided for @signDetailElement.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get signDetailElement;

  /// No description provided for @signDetailModality.
  ///
  /// In en, this message translates to:
  /// **'Modality'**
  String get signDetailModality;

  /// No description provided for @signDetailRuler.
  ///
  /// In en, this message translates to:
  /// **'Ruling planet'**
  String get signDetailRuler;

  /// No description provided for @signDetailDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get signDetailDates;

  /// No description provided for @signDetailReadHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Read horoscope'**
  String get signDetailReadHoroscope;

  /// No description provided for @signDetailPersonality.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get signDetailPersonality;

  /// No description provided for @signAriesKeywords.
  ///
  /// In en, this message translates to:
  /// **'Courageous · Energetic · Direct'**
  String get signAriesKeywords;

  /// No description provided for @signAriesDescription.
  ///
  /// In en, this message translates to:
  /// **'The first sign of the zodiac, Aries charges ahead with the spark of new beginnings. Ruled by Mars, it is bold, competitive and quick to act, at its best when leading the way or taking on a challenge. Patience is its lifelong lesson.'**
  String get signAriesDescription;

  /// No description provided for @signTaurusKeywords.
  ///
  /// In en, this message translates to:
  /// **'Steady · Sensual · Loyal'**
  String get signTaurusKeywords;

  /// No description provided for @signTaurusDescription.
  ///
  /// In en, this message translates to:
  /// **'Taurus values comfort, beauty and things that last. Ruled by Venus, it moves at its own unhurried pace, building security through patience and persistence. Dependable and devoted, it can also be wonderfully stubborn.'**
  String get signTaurusDescription;

  /// No description provided for @signGeminiKeywords.
  ///
  /// In en, this message translates to:
  /// **'Curious · Witty · Adaptable'**
  String get signGeminiKeywords;

  /// No description provided for @signGeminiDescription.
  ///
  /// In en, this message translates to:
  /// **'Gemini lives for ideas, conversation and variety. Ruled by Mercury, it learns fast, connects people and sees every side of a story. Its restless mind thrives on novelty, though focus can be a challenge.'**
  String get signGeminiDescription;

  /// No description provided for @signCancerKeywords.
  ///
  /// In en, this message translates to:
  /// **'Caring · Intuitive · Protective'**
  String get signCancerKeywords;

  /// No description provided for @signCancerDescription.
  ///
  /// In en, this message translates to:
  /// **'Cancer is the zodiac\'s nurturer, guided by the Moon and deep feeling. It treasures home, family and memories, and protects loved ones fiercely. Beneath its sensitive shell lies remarkable emotional strength.'**
  String get signCancerDescription;

  /// No description provided for @signLeoKeywords.
  ///
  /// In en, this message translates to:
  /// **'Warm · Generous · Expressive'**
  String get signLeoKeywords;

  /// No description provided for @signLeoDescription.
  ///
  /// In en, this message translates to:
  /// **'Ruled by the Sun, Leo shines with warmth, creativity and confidence. It loves to celebrate, to perform and to lift others up with big-hearted loyalty. Recognition fuels it, and pride can be its blind spot.'**
  String get signLeoDescription;

  /// No description provided for @signVirgoKeywords.
  ///
  /// In en, this message translates to:
  /// **'Thoughtful · Precise · Helpful'**
  String get signVirgoKeywords;

  /// No description provided for @signVirgoDescription.
  ///
  /// In en, this message translates to:
  /// **'Virgo notices the details others miss. Ruled by Mercury, it brings clear thinking, practical skill and a genuine wish to be useful. It strives for improvement in everything, and learning to be gentle with itself matters.'**
  String get signVirgoDescription;

  /// No description provided for @signLibraKeywords.
  ///
  /// In en, this message translates to:
  /// **'Harmonious · Charming · Fair'**
  String get signLibraKeywords;

  /// No description provided for @signLibraDescription.
  ///
  /// In en, this message translates to:
  /// **'Libra seeks balance, beauty and fairness in every relationship. Ruled by Venus, it is diplomatic, sociable and gifted at seeing both sides. Decisions can take time, because it wants the outcome to feel right for everyone.'**
  String get signLibraDescription;

  /// No description provided for @signScorpioKeywords.
  ///
  /// In en, this message translates to:
  /// **'Intense · Loyal · Perceptive'**
  String get signScorpioKeywords;

  /// No description provided for @signScorpioDescription.
  ///
  /// In en, this message translates to:
  /// **'Scorpio feels everything deeply and sees beneath the surface. Associated with Pluto and Mars, it is magnetic, determined and fiercely loyal. It values trust above all, and its power lies in transformation.'**
  String get signScorpioDescription;

  /// No description provided for @signSagittariusKeywords.
  ///
  /// In en, this message translates to:
  /// **'Adventurous · Optimistic · Free-spirited'**
  String get signSagittariusKeywords;

  /// No description provided for @signSagittariusDescription.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius is the zodiac\'s explorer, always seeking the next horizon. Ruled by Jupiter, it is enthusiastic, philosophical and honest to the point of bluntness. Freedom and meaning keep its fire burning.'**
  String get signSagittariusDescription;

  /// No description provided for @signCapricornKeywords.
  ///
  /// In en, this message translates to:
  /// **'Ambitious · Disciplined · Responsible'**
  String get signCapricornKeywords;

  /// No description provided for @signCapricornDescription.
  ///
  /// In en, this message translates to:
  /// **'Capricorn climbs steadily toward its goals. Ruled by Saturn, it is practical, patient and serious about its commitments, with a dry sense of humour. Success is built step by step, and rest must be earned and learned.'**
  String get signCapricornDescription;

  /// No description provided for @signAquariusKeywords.
  ///
  /// In en, this message translates to:
  /// **'Original · Independent · Humanitarian'**
  String get signAquariusKeywords;

  /// No description provided for @signAquariusDescription.
  ///
  /// In en, this message translates to:
  /// **'Aquarius thinks ahead of its time. Associated with Uranus and Saturn, it is inventive, principled and devoted to friends and causes. It prizes independence and may seem detached, yet it cares about the bigger picture.'**
  String get signAquariusDescription;

  /// No description provided for @signPiscesKeywords.
  ///
  /// In en, this message translates to:
  /// **'Imaginative · Compassionate · Dreamy'**
  String get signPiscesKeywords;

  /// No description provided for @signPiscesDescription.
  ///
  /// In en, this message translates to:
  /// **'The final sign, Pisces flows between reality and imagination. Associated with Neptune and Jupiter, it is empathetic, artistic and deeply intuitive. It absorbs the feelings around it, so healthy boundaries help it thrive.'**
  String get signPiscesDescription;

  /// No description provided for @horoscopeTitle.
  ///
  /// In en, this message translates to:
  /// **'{sign} horoscope'**
  String horoscopeTitle(String sign);

  /// No description provided for @periodDaily.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodDaily;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodMonthly;

  /// No description provided for @horoscopeLoading.
  ///
  /// In en, this message translates to:
  /// **'Reading the stars…'**
  String get horoscopeLoading;

  /// No description provided for @horoscopeWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String horoscopeWeekOf(String date);

  /// No description provided for @horoscopeStaleNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — showing the reading saved on {date}.'**
  String horoscopeStaleNotice(String date);

  /// Required attribution link (provider terms). Keep the brand name untranslated.
  ///
  /// In en, this message translates to:
  /// **'Powered by FreeHoroscopeAPI'**
  String get horoscopeAttribution;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'You seem to be offline. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The stars are hidden right now. Please try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorDataFormat.
  ///
  /// In en, this message translates to:
  /// **'We received an unexpected answer from the horoscope service.'**
  String get errorDataFormat;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a horoscope to keep it here.'**
  String get favoritesEmptyBody;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your astrological profile'**
  String get profileEmptyTitle;

  /// No description provided for @profileEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your birth details to discover your Sun, Moon and Rising signs.'**
  String get profileEmptyBody;

  /// No description provided for @profileLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get profileLicenses;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Lost among the stars'**
  String get notFoundTitle;

  /// No description provided for @notFoundAction.
  ///
  /// In en, this message translates to:
  /// **'Back to today'**
  String get notFoundAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

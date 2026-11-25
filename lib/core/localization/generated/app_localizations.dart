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

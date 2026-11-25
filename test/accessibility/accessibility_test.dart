import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/core/localization/generated/app_localizations.dart';
import 'package:mystic_horoscope/core/theme/app_theme.dart';
import 'package:mystic_horoscope/core/widgets/cosmic_background.dart';
import 'package:mystic_horoscope/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:mystic_horoscope/features/favorites/presentation/pages/favorites_page.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/bloc/horoscope_bloc.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_place.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/natal_chart.dart';
import 'package:mystic_horoscope/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mystic_horoscope/features/profile/presentation/pages/birth_details_page.dart';
import 'package:mystic_horoscope/features/profile/presentation/pages/profile_page.dart';
import 'package:mystic_horoscope/features/today/presentation/pages/today_page.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/pages/sign_detail_page.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/pages/signs_page.dart';

import '../helpers/pump_app.dart';
import '../helpers/sample_data.dart';

class _MockHoroscopeBloc extends MockBloc<HoroscopeEvent, HoroscopeState>
    implements HoroscopeBloc {}

final _profile = ProfileLoaded(
  birthData: BirthData(
    date: DateTime(1990, 7, 15),
    time: (hour: 16, minute: 30),
    place: const BirthPlace(
      name: 'Kraków',
      region: 'Lesser Poland',
      country: 'Poland',
      latitude: 50.06,
      longitude: 19.94,
      timeZoneId: 'Europe/Warsaw',
    ),
  ),
  chart: const NatalChart(
    sun: KnownPlacement(ZodiacSign.cancer),
    moon: AmbiguousPlacement([ZodiacSign.aries, ZodiacSign.taurus]),
    ascendant: KnownPlacement(ZodiacSign.scorpio),
  ),
);

/// Screens under test, built with stubbed state.
Map<String, Widget Function()> _screens() {
  final horoscopeBloc = _MockHoroscopeBloc();
  when(() => horoscopeBloc.sign).thenReturn(ZodiacSign.leo);
  when(() => horoscopeBloc.state).thenReturn(
    HoroscopeState(
      period: HoroscopePeriod.daily,
      status: HoroscopeStatus.success,
      horoscope: sampleHoroscope(),
    ),
  );
  return {
    'Today': () => TodayPage(now: DateTime(2026, 11, 25)),
    'Signs': () => const SignsPage(),
    'Sign detail': () => const SignDetailPage(sign: ZodiacSign.sagittarius),
    'Horoscope': () => BlocProvider<HoroscopeBloc>.value(
      value: horoscopeBloc,
      child: const HoroscopeView(),
    ),
    'Favorites': () => const FavoritesPage(),
    'Profile': () => const ProfilePage(),
    'Birth form': () => BirthDetailsPage(searchPlaces: (_) async => const []),
  };
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  double textScale = 1,
}) async {
  tester.enableReducedMotion();
  // A small phone (360×740 dp), not the default 800×600 test surface.
  tester.view
    ..physicalSize = const Size(1080, 2220)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    withAppCubits(
      profile: profileCubitWith(_profile),
      favorites: favoritesCubitWith(
        FavoritesState(items: [sampleFavorite()], loaded: true),
      ),
      MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // Same backdrop as the app, so contrast is measured on the sky.
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: CosmicBackground(child: child!),
        ),
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final MapEntry(key: name, value: build) in _screens().entries) {
    group(name, () {
      testWidgets('meets tap target, label and contrast guidelines', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await _pump(tester, build());
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        semantics.dispose();
      });

      testWidgets('lays out without overflow at 200% text size', (
        tester,
      ) async {
        await _pump(tester, build(), textScale: 2);
        expect(tester.takeException(), isNull);
      });
    });
  }
}

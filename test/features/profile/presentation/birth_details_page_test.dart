import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_place.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/natal_chart.dart';
import 'package:mystic_horoscope/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mystic_horoscope/features/profile/presentation/pages/birth_details_page.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

import '../../../helpers/pump_app.dart';

const _krakow = BirthPlace(
  name: 'Kraków',
  region: 'Lesser Poland',
  country: 'Poland',
  latitude: 50.0614,
  longitude: 19.9366,
  timeZoneId: 'Europe/Warsaw',
);

void main() {
  setUpAll(() => registerFallbackValue(BirthData(date: DateTime(2000))));

  testWidgets('save is disabled until a date is chosen', (tester) async {
    await tester.pumpLocalized(
      BirthDetailsPage(searchPlaces: (_) async => const []),
    );
    final save = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save'),
    );
    expect(save.onPressed, isNull);
  });

  testWidgets('editing keeps existing data and saves the chosen place', (
    tester,
  ) async {
    final cubit = profileCubitWith(
      ProfileLoaded(
        birthData: BirthData(date: DateTime(1990, 7, 15)),
        chart: const NatalChart(
          sun: KnownPlacement(ZodiacSign.cancer),
          moon: KnownPlacement(ZodiacSign.aries),
          ascendant: UnavailablePlacement(UnavailableReason.needsTimeAndPlace),
        ),
      ),
    );
    when(() => cubit.save(any())).thenAnswer((_) async {});

    await tester.pumpLocalized(
      BirthDetailsPage(
        searchPlaces: (q) async =>
            q.toLowerCase().startsWith('kra') ? [_krakow] : const [],
      ),
      profile: cubit,
    );

    expect(find.text('July 15, 1990'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Kra');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kraków'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    final saved =
        verify(() => cubit.save(captureAny())).captured.single as BirthData;
    expect(saved.date, DateTime(1990, 7, 15));
    expect(saved.time, isNull);
    expect(saved.place, _krakow);
  });

  testWidgets('prefills when the profile finishes loading after opening', (
    tester,
  ) async {
    final cubit = MockProfileCubit();
    when(() => cubit.state).thenReturn(const ProfileLoading());
    whenListen(
      cubit,
      Stream.value(
        ProfileLoaded(
          birthData: BirthData(date: DateTime(1990, 7, 15), place: _krakow),
          chart: const NatalChart(
            sun: KnownPlacement(ZodiacSign.cancer),
            moon: KnownPlacement(ZodiacSign.aries),
            ascendant: UnavailablePlacement(
              UnavailableReason.needsTimeAndPlace,
            ),
          ),
        ),
      ),
    );

    await tester.pumpLocalized(
      BirthDetailsPage(searchPlaces: (_) async => const []),
      profile: cubit,
    );

    expect(find.text('July 15, 1990'), findsOneWidget);
    expect(find.text('Kraków, Lesser Poland, Poland'), findsOneWidget);
  });
}

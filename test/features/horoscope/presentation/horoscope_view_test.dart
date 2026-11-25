import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/core/error/failures.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/bloc/horoscope_bloc.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

import '../../../helpers/pump_app.dart';

class _MockBloc extends MockBloc<HoroscopeEvent, HoroscopeState>
    implements HoroscopeBloc {}

void main() {
  late _MockBloc bloc;

  final reading = Horoscope(
    sign: ZodiacSign.leo,
    period: HoroscopePeriod.daily,
    periodStart: DateTime(2026, 11, 25),
    text: 'A reading from the provider.',
    fetchedAt: DateTime(2026, 11, 24),
  );

  setUp(() {
    bloc = _MockBloc();
    when(() => bloc.sign).thenReturn(ZodiacSign.leo);
  });

  Future<void> pump(WidgetTester tester, HoroscopeState state) {
    when(() => bloc.state).thenReturn(state);
    return tester.pumpLocalized(
      BlocProvider<HoroscopeBloc>.value(
        value: bloc,
        child: const HoroscopeView(),
      ),
    );
  }

  testWidgets('shows the reading, its date and the attribution', (
    tester,
  ) async {
    await pump(
      tester,
      HoroscopeState(
        period: HoroscopePeriod.daily,
        status: HoroscopeStatus.success,
        horoscope: reading,
      ),
    );
    expect(find.text('A reading from the provider.'), findsOneWidget);
    expect(find.text('WEDNESDAY, NOVEMBER 25'), findsOneWidget);
    expect(find.text('Powered by FreeHoroscopeAPI'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off), findsNothing);
  });

  testWidgets('flags stale readings shown while offline', (tester) async {
    await pump(
      tester,
      HoroscopeState(
        period: HoroscopePeriod.daily,
        status: HoroscopeStatus.success,
        horoscope: reading.copyWith(isStale: true),
      ),
    );
    expect(
      find.text("You're offline — showing the reading saved on Nov 24."),
      findsOneWidget,
    );
  });

  testWidgets('shows offline error with retry', (tester) async {
    await pump(
      tester,
      const HoroscopeState(
        period: HoroscopePeriod.daily,
        status: HoroscopeStatus.failure,
        failure: NetworkFailure(),
      ),
    );
    expect(
      find.text('You seem to be offline. Check your connection and try again.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Try again'));
    verify(() => bloc.add(const HoroscopeRefreshRequested())).called(1);
  });

  testWidgets('period switch dispatches an event', (tester) async {
    await pump(tester, const HoroscopeState(period: HoroscopePeriod.daily));
    await tester.tap(find.text('This month'));
    verify(
      () => bloc.add(const HoroscopePeriodSelected(HoroscopePeriod.monthly)),
    ).called(1);
  });
}

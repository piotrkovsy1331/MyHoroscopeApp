import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/core/error/failures.dart';
import 'package:mystic_horoscope/core/utils/result.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/horoscope/domain/usecases/get_horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/bloc/horoscope_bloc.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

class _MockGetHoroscope extends Mock implements GetHoroscope {}

Horoscope _h(HoroscopePeriod p) => Horoscope(
  sign: ZodiacSign.leo,
  period: p,
  periodStart: DateTime(2026, 11, 25),
  text: '${p.name} text',
  fetchedAt: DateTime(2026, 11, 25),
);

void main() {
  late _MockGetHoroscope getHoroscope;

  setUpAll(() {
    registerFallbackValue(ZodiacSign.aries);
    registerFallbackValue(HoroscopePeriod.daily);
  });

  setUp(() => getHoroscope = _MockGetHoroscope());

  void stub(HoroscopePeriod p, Result<Horoscope> r, {bool force = false}) =>
      when(() => getHoroscope(ZodiacSign.leo, p, forceRefresh: force))
          .thenAnswer((_) async => r);

  HoroscopeBloc build() =>
      HoroscopeBloc(sign: ZodiacSign.leo, getHoroscope: getHoroscope);

  blocTest<HoroscopeBloc, HoroscopeState>(
    'loads the selected period',
    setUp: () =>
        stub(HoroscopePeriod.weekly, Success(_h(HoroscopePeriod.weekly))),
    build: build,
    act: (bloc) =>
        bloc.add(const HoroscopePeriodSelected(HoroscopePeriod.weekly)),
    expect: () => [
      const HoroscopeState(period: HoroscopePeriod.weekly),
      HoroscopeState(
        period: HoroscopePeriod.weekly,
        status: HoroscopeStatus.success,
        horoscope: _h(HoroscopePeriod.weekly),
      ),
    ],
  );

  blocTest<HoroscopeBloc, HoroscopeState>(
    'emits failure',
    setUp: () => stub(HoroscopePeriod.daily, const Error(NetworkFailure())),
    build: build,
    act: (bloc) =>
        bloc.add(const HoroscopePeriodSelected(HoroscopePeriod.daily)),
    expect: () => [
      const HoroscopeState(period: HoroscopePeriod.daily),
      const HoroscopeState(
        period: HoroscopePeriod.daily,
        status: HoroscopeStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );

  blocTest<HoroscopeBloc, HoroscopeState>(
    'refresh keeps the current text visible while reloading',
    setUp: () => stub(
      HoroscopePeriod.daily,
      Success(_h(HoroscopePeriod.daily)),
      force: true,
    ),
    build: build,
    seed: () => HoroscopeState(
      period: HoroscopePeriod.daily,
      status: HoroscopeStatus.success,
      horoscope: _h(HoroscopePeriod.daily),
    ),
    act: (bloc) => bloc.add(const HoroscopeRefreshRequested()),
    expect: () => [
      HoroscopeState(
        period: HoroscopePeriod.daily,
        horoscope: _h(HoroscopePeriod.daily),
      ),
      HoroscopeState(
        period: HoroscopePeriod.daily,
        status: HoroscopeStatus.success,
        horoscope: _h(HoroscopePeriod.daily),
      ),
    ],
  );

  blocTest<HoroscopeBloc, HoroscopeState>(
    'a slow older request never overwrites a newer period',
    setUp: () {
      final slowDaily = Completer<Result<Horoscope>>();
      when(() => getHoroscope(ZodiacSign.leo, HoroscopePeriod.daily))
          .thenAnswer((_) => slowDaily.future);
      stub(HoroscopePeriod.monthly, Success(_h(HoroscopePeriod.monthly)));
      // Completes after the monthly request has already finished.
      Future<void>.delayed(
        const Duration(milliseconds: 20),
        () => slowDaily.complete(Success(_h(HoroscopePeriod.daily))),
      );
    },
    build: build,
    act: (bloc) => bloc
      ..add(const HoroscopePeriodSelected(HoroscopePeriod.daily))
      ..add(const HoroscopePeriodSelected(HoroscopePeriod.monthly)),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const HoroscopeState(period: HoroscopePeriod.daily),
      const HoroscopeState(period: HoroscopePeriod.monthly),
      HoroscopeState(
        period: HoroscopePeriod.monthly,
        status: HoroscopeStatus.success,
        horoscope: _h(HoroscopePeriod.monthly),
      ),
    ],
  );
}

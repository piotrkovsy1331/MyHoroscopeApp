import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/core/error/failures.dart';
import 'package:mystic_horoscope/core/utils/result.dart';
import 'package:mystic_horoscope/features/horoscope/data/datasources/horoscope_local_data_source.dart';
import 'package:mystic_horoscope/features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'package:mystic_horoscope/features/horoscope/data/repositories/horoscope_repository_impl.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

class _MockRemote extends Mock implements HoroscopeRemoteDataSource {}

class _MockLocal extends Mock implements HoroscopeLocalDataSource {}

Horoscope _h(HoroscopePeriod period, DateTime fetchedAt, [String text = 't']) =>
    Horoscope(
      sign: ZodiacSign.leo,
      period: period,
      periodStart: DateTime(fetchedAt.year, fetchedAt.month, fetchedAt.day),
      text: text,
      fetchedAt: fetchedAt,
    );

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  // Wednesday 2026-11-25 10:00.
  final now = DateTime(2026, 11, 25, 10);

  HoroscopeRepositoryImpl repo() =>
      HoroscopeRepositoryImpl(remote: remote, local: local, clock: () => now);

  setUpAll(() {
    registerFallbackValue(_h(HoroscopePeriod.daily, now));
    registerFallbackValue(ZodiacSign.aries);
    registerFallbackValue(HoroscopePeriod.daily);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    when(() => local.write(any())).thenAnswer((_) async {});
  });

  test('serves a reading fetched today from cache without network', () async {
    final cached = _h(HoroscopePeriod.daily, DateTime(2026, 11, 25, 7));
    when(() => local.read(ZodiacSign.leo, HoroscopePeriod.daily))
        .thenAnswer((_) async => cached);

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
    );

    expect((result as Success<Horoscope>).value, cached);
    verifyNever(() => remote.fetch(any(), any()));
  });

  test('weekly cache from Monday of the same week is current', () async {
    final cached = _h(HoroscopePeriod.weekly, DateTime(2026, 11, 23, 9));
    when(() => local.read(ZodiacSign.leo, HoroscopePeriod.weekly))
        .thenAnswer((_) async => cached);

    await repo().getHoroscope(ZodiacSign.leo, HoroscopePeriod.weekly);
    verifyNever(() => remote.fetch(any(), any()));
  });

  test('fetches and caches when the cached reading is outdated', () async {
    final old = _h(HoroscopePeriod.daily, DateTime(2026, 11, 24, 22), 'old');
    final fresh = _h(HoroscopePeriod.daily, now, 'fresh');
    when(() => local.read(any(), any())).thenAnswer((_) async => old);
    when(() => remote.fetch(ZodiacSign.leo, HoroscopePeriod.daily))
        .thenAnswer((_) async => fresh);

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
    );

    expect((result as Success<Horoscope>).value, fresh);
    verify(() => local.write(fresh)).called(1);
  });

  test('forceRefresh bypasses a current cache', () async {
    final cached = _h(HoroscopePeriod.daily, now, 'cached');
    final fresh = _h(HoroscopePeriod.daily, now, 'fresh');
    when(() => local.read(any(), any())).thenAnswer((_) async => cached);
    when(() => remote.fetch(any(), any())).thenAnswer((_) async => fresh);

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
      forceRefresh: true,
    );
    expect((result as Success<Horoscope>).value.text, 'fresh');
  });

  test('falls back to stale cache when offline', () async {
    final old = _h(HoroscopePeriod.daily, DateTime(2026, 11, 20), 'old');
    when(() => local.read(any(), any())).thenAnswer((_) async => old);
    when(() => remote.fetch(any(), any())).thenThrow(const NetworkException());

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
    );

    final value = (result as Success<Horoscope>).value;
    expect(value.text, 'old');
    expect(value.isStale, isTrue);
  });

  test('returns a failure when offline with empty cache', () async {
    when(() => local.read(any(), any())).thenAnswer((_) async => null);
    when(() => remote.fetch(any(), any())).thenThrow(const NetworkException());

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
    );
    expect((result as Error<Horoscope>).failure, const NetworkFailure());
  });

  test('maps unexpected errors to UnexpectedFailure', () async {
    when(() => local.read(any(), any())).thenAnswer((_) async => null);
    when(() => remote.fetch(any(), any())).thenThrow(TypeError());

    final result = await repo().getHoroscope(
      ZodiacSign.leo,
      HoroscopePeriod.daily,
    );
    expect((result as Error<Horoscope>).failure, const UnexpectedFailure());
  });
}

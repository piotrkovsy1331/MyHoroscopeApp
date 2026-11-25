import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/natal_chart.dart';
import 'package:mystic_horoscope/features/profile/domain/repositories/profile_repository.dart';
import 'package:mystic_horoscope/features/profile/domain/services/natal_calculator.dart';
import 'package:mystic_horoscope/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

class _MockRepo extends Mock implements ProfileRepository {}

class _MockCalculator extends Mock implements NatalCalculator {}

void main() {
  late _MockRepo repo;
  late _MockCalculator calculator;
  final data = BirthData(date: DateTime(1990, 7, 15));
  const chart = NatalChart(
    sun: KnownPlacement(ZodiacSign.cancer),
    moon: KnownPlacement(ZodiacSign.aries),
    ascendant: UnavailablePlacement(UnavailableReason.needsTimeAndPlace),
  );

  setUpAll(() => registerFallbackValue(data));

  setUp(() {
    repo = _MockRepo();
    calculator = _MockCalculator();
    when(() => calculator.calculate(any())).thenReturn(chart);
    when(() => repo.save(any())).thenAnswer((_) async {});
    when(() => repo.clear()).thenAnswer((_) async {});
  });

  ProfileCubit build() =>
      ProfileCubit(repository: repo, calculator: calculator);

  blocTest<ProfileCubit, ProfileState>(
    'load without stored data emits empty',
    setUp: () => when(() => repo.load()).thenAnswer((_) async => null),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [const ProfileEmpty()],
  );

  blocTest<ProfileCubit, ProfileState>(
    'load computes the chart of stored data',
    setUp: () => when(() => repo.load()).thenAnswer((_) async => data),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [ProfileLoaded(birthData: data, chart: chart)],
    verify: (cubit) =>
        expect((cubit.state as ProfileLoaded).sunSign, ZodiacSign.cancer),
  );

  blocTest<ProfileCubit, ProfileState>(
    'save persists and emits loaded; clear removes',
    build: build,
    act: (cubit) async {
      await cubit.save(data);
      await cubit.clear();
    },
    expect: () => [
      ProfileLoaded(birthData: data, chart: chart),
      const ProfileEmpty(),
    ],
    verify: (_) {
      verify(() => repo.save(data)).called(1);
      verify(() => repo.clear()).called(1);
    },
  );

  test('sunSign is null when the Sun is ambiguous', () {
    final state = ProfileLoaded(
      birthData: data,
      chart: const NatalChart(
        sun: AmbiguousPlacement([ZodiacSign.pisces, ZodiacSign.aries]),
        moon: KnownPlacement(ZodiacSign.leo),
        ascendant: UnavailablePlacement(UnavailableReason.needsTimeAndPlace),
      ),
    );
    expect(state.sunSign, isNull);
  });
}

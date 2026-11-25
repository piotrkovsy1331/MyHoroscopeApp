import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/birth_data.dart';
import 'package:mystic_horoscope/features/profile/domain/entities/natal_chart.dart';
import 'package:mystic_horoscope/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mystic_horoscope/features/profile/presentation/pages/profile_page.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('empty profile invites to add birth details', (tester) async {
    await tester.pumpLocalized(const ProfilePage());
    expect(find.text('Add birth details'), findsOneWidget);
    expect(find.textContaining('stored only on this device'), findsOneWidget);
  });

  testWidgets('date-only profile never shows uncertain results as facts', (
    tester,
  ) async {
    await tester.pumpLocalized(
      const ProfilePage(),
      profile: profileCubitWith(
        ProfileLoaded(
          birthData: BirthData(date: DateTime(2024, 3, 20)),
          chart: const NatalChart(
            sun: AmbiguousPlacement([ZodiacSign.pisces, ZodiacSign.aries]),
            moon: KnownPlacement(ZodiacSign.cancer),
            ascendant: UnavailablePlacement(
              UnavailableReason.needsTimeAndPlace,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Pisces or Aries'), findsOneWidget);
    expect(find.text('Add your birth time to pin this down.'), findsOneWidget);
    expect(find.text('Cancer'), findsOneWidget);
    expect(find.text('Needs your birth time and birthplace.'), findsOneWidget);
    expect(find.text('Time unknown'), findsOneWidget);
    expect(find.text('Place unknown'), findsOneWidget);
    // No personal horoscope shortcut while the Sun sign is uncertain.
    expect(find.text('Read my horoscope'), findsNothing);
  });
}

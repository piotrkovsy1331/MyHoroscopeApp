import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mystic_horoscope/features/today/presentation/pages/today_page.dart';

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('read a horoscope, save it and find it in Favorites', (
    tester,
  ) async {
    await setUpApp();
    await tester.launchApp();
    expect(find.byType(TodayPage), findsOneWidget);

    await tester.tapAndSettle(find.text('Signs'));
    await tester.tapAndSettle(find.text('Leo'));
    await tester.tapAndSettle(find.text('Read horoscope'));
    expect(find.text('Fake leo daily reading.'), findsOneWidget);

    await tester.tapAndSettle(find.text('This month'));
    expect(find.text('Fake leo monthly reading.'), findsOneWidget);

    await tester.tapAndSettle(find.byTooltip('Save to favorites'));
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tapAndSettle(find.text('Favorites'));
    expect(find.text('Fake leo monthly reading.'), findsOneWidget);

    await tester.tapAndSettle(find.text('Fake leo monthly reading.'));
    expect(find.textContaining('Saved on'), findsOneWidget);
  });

  testWidgets('offline without cache shows an error, retry recovers', (
    tester,
  ) async {
    final remote = await setUpApp();
    remote.offline = true;
    await tester.launchApp();

    await tester.tapAndSettle(find.text('Signs'));
    await tester.tapAndSettle(find.text('Aries'));
    await tester.tapAndSettle(find.text('Read horoscope'));
    expect(
      find.text('You seem to be offline. Check your connection and try again.'),
      findsOneWidget,
    );

    remote.offline = false;
    await tester.tapAndSettle(find.text('Try again'));
    expect(find.text('Fake aries daily reading.'), findsOneWidget);
  });

  testWidgets('cached reading is served offline and flagged', (tester) async {
    final remote = await setUpApp();
    await tester.launchApp();
    await tester.tapAndSettle(find.text('Signs'));
    await tester.tapAndSettle(find.text('Virgo'));
    await tester.tapAndSettle(find.text('Read horoscope'));
    expect(find.text('Fake virgo daily reading.'), findsOneWidget);

    // Pull to refresh while offline keeps the saved text, marked stale.
    remote.offline = true;
    await tester.fling(
      find.text('Fake virgo daily reading.'),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.text('Fake virgo daily reading.'), findsOneWidget);
    expect(find.textContaining("You're offline"), findsOneWidget);
  });

  testWidgets('create a profile with a birthplace', (tester) async {
    await setUpApp();
    await tester.launchApp();

    await tester.tapAndSettle(find.text('Profile'));
    await tester.tapAndSettle(find.text('Add birth details'));
    await tester.tapAndSettle(find.text('Date of birth'));
    await tester.tapAndSettle(find.text('OK')); // accept the default date

    await tester.enterText(find.byType(TextField), 'Krak');
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text('Kraków'));
    await tester.tapAndSettle(find.widgetWithText(FilledButton, 'Save'));

    expect(find.text('Your chart'), findsOneWidget);
    expect(find.text('Kraków, Lesser Poland, Poland'), findsOneWidget);
    expect(find.text('Needs your birth time and birthplace.'), findsOneWidget);
    expect(find.text('Time unknown'), findsOneWidget);
  });
}

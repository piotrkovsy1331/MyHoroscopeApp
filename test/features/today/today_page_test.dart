import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/features/today/presentation/pages/today_page.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows computed Moon phase and Sun season for the date', (
    tester,
  ) async {
    // 2024-01-25 was a full moon; the Sun was in Aquarius.
    await tester.pumpLocalized(TodayPage(now: DateTime(2024, 1, 25, 20)));

    expect(find.text('Thursday, January 25, 2024'), findsOneWidget);
    expect(find.text('Full Moon'), findsOneWidget);
    expect(find.text('100% illuminated'), findsOneWidget);
    expect(
      find.text('The Sun is travelling through Aquarius.'),
      findsOneWidget,
    );
  });
}

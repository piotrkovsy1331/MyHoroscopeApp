import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/app.dart';
import 'package:mystic_horoscope/core/router/app_router.dart';
import 'package:mystic_horoscope/features/horoscope/presentation/pages/horoscope_page.dart';
import 'package:mystic_horoscope/features/today/presentation/pages/today_page.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/pages/sign_detail_page.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/widgets/sign_tile.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('splash leads to Today, then signs → detail → horoscope', (
    tester,
  ) async {
    tester.enableReducedMotion();
    await tester.pumpWidget(MysticApp(router: createAppRouter()));

    expect(find.text('Your guide to the stars'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(find.byType(TodayPage), findsOneWidget);

    await tester.tap(find.text('Signs'));
    await tester.pumpAndSettle();
    expect(find.byType(SignTile), findsWidgets);

    await tester.tap(find.text('Leo'));
    await tester.pumpAndSettle();
    expect(find.byType(SignDetailPage), findsOneWidget);
    expect(find.text('Sun'), findsOneWidget); // Leo's ruler
    expect(find.text('Fixed'), findsOneWidget);

    final readButton = find.text('Read horoscope');
    await tester.scrollUntilVisible(
      readButton,
      200,
      scrollable: find
          .descendant(
            of: find.byType(SignDetailPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(readButton);
    await tester.pumpAndSettle();
    expect(find.byType(HoroscopePage), findsOneWidget);
    expect(find.text('Leo horoscope'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('This month'), findsOneWidget);

    await tester.tap(find.text('This week'));
    await tester.pumpAndSettle();
    final segmented = tester.widget<SegmentedButton<Object>>(
      find.byWidgetPredicate((w) => w is SegmentedButton),
    );
    expect(segmented.selected.single.toString(), 'HoroscopePeriod.weekly');
  });

  testWidgets('unknown sign id shows the not-found page', (tester) async {
    tester.enableReducedMotion();
    await tester.pumpWidget(
      MysticApp(router: createAppRouter(initialLocation: '/signs/ophiuchus')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lost among the stars'), findsOneWidget);
    await tester.tap(find.text('Back to today'));
    await tester.pumpAndSettle();
    expect(find.byType(TodayPage), findsOneWidget);
  });
}

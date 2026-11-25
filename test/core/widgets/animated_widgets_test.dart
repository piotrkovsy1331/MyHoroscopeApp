import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/widgets/constellation_view.dart';
import 'package:mystic_horoscope/core/widgets/fade_slide_in.dart';
import 'package:mystic_horoscope/core/widgets/star_field.dart';

Widget _wrap(Widget child, {bool reduceMotion = false}) => MediaQuery(
  data: MediaQueryData(disableAnimations: reduceMotion),
  child: Directionality(textDirection: TextDirection.ltr, child: child),
);

void main() {
  const shape = ConstellationShape(
    stars: [Offset(0.1, 0.1), Offset(0.9, 0.9)],
    lines: [(0, 1)],
  );

  testWidgets('FadeSlideIn ends fully visible', (tester) async {
    await tester.pumpWidget(_wrap(const FadeSlideIn(child: Text('hi'))));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

    await tester.pumpAndSettle();
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('FadeSlideIn is instant with reduced motion', (tester) async {
    await tester.pumpWidget(
      _wrap(const FadeSlideIn(child: Text('hi')), reduceMotion: true),
    );
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('StarField does not schedule frames with reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const StarField(), reduceMotion: true));
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('StarField animates and disposes cleanly', (tester) async {
    await tester.pumpWidget(_wrap(const StarField()));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ConstellationView completes its drawing', (tester) async {
    await tester.pumpWidget(_wrap(const ConstellationView(shape: shape)));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}

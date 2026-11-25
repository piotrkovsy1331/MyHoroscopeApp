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

  testWidgets('StarField schedules no frames with reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const StarField(), reduceMotion: true));
    await tester.binding.delayed(const Duration(milliseconds: 200));
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('StarField repaints at ~30 fps, not every vsync', (tester) async {
    await tester.pumpWidget(_wrap(const StarField()));
    await tester.pump();
    // No repaint is requested before the 33 ms interval elapses...
    await tester.binding.delayed(const Duration(milliseconds: 20));
    expect(tester.binding.hasScheduledFrame, isFalse);
    // ...and one is requested once it does.
    await tester.binding.delayed(const Duration(milliseconds: 20));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox()); // cancels the timer
  });

  testWidgets('StarField stops while the app is not in the foreground', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const StarField()));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    await tester.binding.delayed(const Duration(milliseconds: 200));
    expect(tester.binding.hasScheduledFrame, isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.binding.delayed(const Duration(milliseconds: 40));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ConstellationView completes its drawing', (tester) async {
    await tester.pumpWidget(_wrap(const ConstellationView(shape: shape)));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}

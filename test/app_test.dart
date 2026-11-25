import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/app.dart';
import 'package:mystic_horoscope/core/router/app_router.dart';

void main() {
  testWidgets('renders home page with localized English texts', (tester) async {
    // The sky animates forever; reduced motion makes the tree settle.
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(MysticApp(router: createAppRouter()));
    await tester.pumpAndSettle();

    expect(find.text('Mystic Horoscope'), findsOneWidget);
    expect(find.text('The stars are aligning…'), findsOneWidget);
  });
}

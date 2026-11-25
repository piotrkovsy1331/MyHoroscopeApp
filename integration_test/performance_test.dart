import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers.dart';

/// Frame timings with all decorative animations running.
/// Run in profile mode on a device:
///   flutter drive --profile --driver=test_driver/integration_test.dart \
///     --target=integration_test/performance_test.dart -d DEVICE_ID
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> wait(WidgetTester tester, Duration d) async {
    final end = DateTime.now().add(d);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets('animated screens', (tester) async {
    await setUpApp();
    await tester.pumpWidget(createRoot());
    await wait(tester, const Duration(seconds: 3)); // splash → Today

    await binding.watchPerformance(
      () => wait(tester, const Duration(seconds: 5)),
      reportKey: 'today_starfield_idle',
    );

    await tester.tap(find.text('Signs'));
    await wait(tester, const Duration(seconds: 1));
    await binding.watchPerformance(() async {
      for (var i = 0; i < 3; i++) {
        await tester.fling(find.byType(GridView), const Offset(0, -500), 2000);
        await wait(tester, const Duration(milliseconds: 800));
        await tester.fling(find.byType(GridView), const Offset(0, 500), 2000);
        await wait(tester, const Duration(milliseconds: 800));
      }
    }, reportKey: 'signs_grid_scroll');

    await binding.watchPerformance(() async {
      await tester.tap(find.text('Scorpio'));
      await wait(tester, const Duration(seconds: 3)); // Hero + constellation
    }, reportKey: 'sign_detail_open');
  });

  // Baseline: identical scrolling with the sky frozen (reduced motion),
  // to separate the cost of the animated background from the rest.
  testWidgets('baseline without background animation', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await setUpApp();
    await tester.pumpWidget(createRoot());
    await wait(tester, const Duration(seconds: 2));
    await tester.tap(find.text('Signs'));
    await wait(tester, const Duration(seconds: 1));
    await binding.watchPerformance(() async {
      for (var i = 0; i < 3; i++) {
        await tester.fling(find.byType(GridView), const Offset(0, -500), 2000);
        await wait(tester, const Duration(milliseconds: 800));
        await tester.fling(find.byType(GridView), const Offset(0, 500), 2000);
        await wait(tester, const Duration(milliseconds: 800));
      }
    }, reportKey: 'signs_grid_scroll_static_sky');
  });
}

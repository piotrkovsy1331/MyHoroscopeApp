import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/localization/generated/app_localizations.dart';
import 'package:mystic_horoscope/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Endless decorative animations never settle, so tests run with the
  /// OS "reduce motion" setting on (which the app honours).
  void enableReducedMotion() {
    platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  /// Pumps a single widget with the app's theme and localizations.
  Future<void> pumpLocalized(Widget widget) async {
    enableReducedMotion();
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
    await pumpAndSettle();
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/bootstrap.dart';
import 'package:mystic_horoscope/core/error/exceptions.dart';
import 'package:mystic_horoscope/features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope.dart';
import 'package:mystic_horoscope/features/horoscope/domain/entities/horoscope_period.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';
import 'package:mystic_horoscope/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Deterministic provider so flows don't depend on the network.
class FakeRemote implements HoroscopeRemoteDataSource {
  bool offline = false;
  int calls = 0;

  @override
  Future<Horoscope> fetch(ZodiacSign sign, HoroscopePeriod period) async {
    calls++;
    if (offline) throw const NetworkException();
    final now = DateTime.now();
    return Horoscope(
      sign: sign,
      period: period,
      periodStart: DateTime(now.year, now.month, now.day),
      text: 'Fake ${sign.name} ${period.name} reading.',
      fetchedAt: now,
    );
  }
}

/// Real DI graph and storage (wiped), with only the provider faked.
Future<FakeRemote> setUpApp() async {
  await sl.reset();
  await SharedPreferencesAsync().clear();
  await initDependencies();
  final fake = FakeRemote();
  sl
    ..unregister<HoroscopeRemoteDataSource>()
    ..registerSingleton<HoroscopeRemoteDataSource>(fake);
  return fake;
}

/// Root widget as in `main` (animations follow the device settings).
Widget createRoot() => createRootWidget();

extension IntegrationTester on WidgetTester {
  Future<void> launchApp({bool reduceMotion = true}) async {
    if (reduceMotion) {
      platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(platformDispatcher.clearAccessibilityFeaturesTestValue);
    }
    await pumpWidget(createRootWidget());
    // Splash (600 ms with reduced motion) → Today.
    await pump(const Duration(seconds: 1));
    await pumpAndSettle();
  }

  /// Taps [finder], first scrolling the visible list if it is not built yet
  /// (lazy lists only build what fits on the real device screen).
  Future<void> tapAndSettle(Finder finder) async {
    if (finder.evaluate().isEmpty) {
      await scrollUntilVisible(
        finder,
        250,
        scrollable: find.byType(Scrollable).hitTestable().first,
      );
    }
    await ensureVisible(finder);
    await tap(finder);
    await pumpAndSettle();
  }
}

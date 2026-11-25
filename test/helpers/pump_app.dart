import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/core/localization/generated/app_localizations.dart';
import 'package:mystic_horoscope/core/theme/app_theme.dart';
import 'package:mystic_horoscope/features/profile/presentation/cubit/profile_cubit.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

/// A profile cubit stub with a fixed [state].
MockProfileCubit profileCubitWith(ProfileState state) {
  final cubit = MockProfileCubit();
  when(() => cubit.state).thenReturn(state);
  return cubit;
}

extension PumpApp on WidgetTester {
  /// Endless decorative animations never settle, so tests run with the
  /// OS "reduce motion" setting on (which the app honours).
  void enableReducedMotion() {
    platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  /// Pumps a widget with the app theme, localizations and a profile cubit
  /// (empty profile unless [profile] is given).
  Future<void> pumpLocalized(Widget widget, {ProfileCubit? profile}) async {
    enableReducedMotion();
    await pumpWidget(
      BlocProvider<ProfileCubit>.value(
        value: profile ?? profileCubitWith(const ProfileEmpty()),
        child: MaterialApp(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
    await pumpAndSettle();
  }
}

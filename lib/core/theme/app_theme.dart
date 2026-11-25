import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Single dark Material 3 theme. The app intentionally has no light mode:
/// the night-sky look is part of the product identity.
abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.gold,
      onPrimary: AppColors.night,
      secondary: AppColors.lavender,
      onSecondary: AppColors.night,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceHigh,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
      onError: AppColors.night,
      outline: Color(0x66D4AF37),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      fontFamily: AppFonts.body,
    );

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.display,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 1.5,
          color: AppColors.goldLight,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.night.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.gold.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.goldLight
                : AppColors.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.gold
                : AppColors.textSecondary,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(
            BorderSide(color: Color(0x66D4AF37)),
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.night
                : AppColors.textPrimary,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.gold
                : Colors.transparent,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.night,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceHigh.withValues(alpha: 0.6),
        side: const BorderSide(color: Color(0x40D4AF37)),
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        shape: const StadiumBorder(),
      ),
      // Pages are transparent over one shared animated sky, so a fade
      // transition is used on both platforms: a horizontal slide would show
      // two pages' content overlapping on the shared background.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    TextStyle? display(TextStyle? s, {double spacing = 1.2}) => s?.copyWith(
      fontFamily: AppFonts.display,
      fontWeight: FontWeight.w700,
      letterSpacing: spacing,
      color: AppColors.goldLight,
    );

    return base
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        )
        .copyWith(
          displaySmall: display(base.displaySmall, spacing: 2),
          headlineMedium: display(base.headlineMedium),
          headlineSmall: display(base.headlineSmall),
          titleLarge: display(base.titleLarge, spacing: 0.8),
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            height: 1.6,
            color: AppColors.textPrimary,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            height: 1.5,
            color: AppColors.textSecondary,
          ),
          labelLarge: base.labelLarge?.copyWith(letterSpacing: 0.6),
        );
  }
}

import 'package:flutter/painting.dart';

/// "Mystic" palette: deep navy/violet night sky with gold accents.
abstract final class AppColors {
  // Backgrounds
  static const night = Color(0xFF070A1F);
  static const navy = Color(0xFF0E1433);
  static const deepViolet = Color(0xFF231544);
  static const surface = Color(0xFF151B3D);
  static const surfaceHigh = Color(0xFF1E2550);

  // Accents
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF1D78A);
  static const lavender = Color(0xFFB9A6F0);

  // Text
  static const textPrimary = Color(0xFFF3EEDC);
  static const textSecondary = Color(0xFFB5B3C9);

  static const error = Color(0xFFFF8A80);

  /// Full-screen background gradient used behind every page.
  static const skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [night, navy, deepViolet],
    stops: [0, 0.55, 1],
  );
}

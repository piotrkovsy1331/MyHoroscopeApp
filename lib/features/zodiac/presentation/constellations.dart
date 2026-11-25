import 'dart:ui';

import '../../../core/widgets/constellation_view.dart';
import '../domain/entities/zodiac_sign.dart';

/// Stylised outlines of the zodiac constellations' main asterisms.
/// Proportions are simplified for a square canvas; they are decorative,
/// not star-chart accurate.
extension ZodiacConstellation on ZodiacSign {
  ConstellationShape get constellation => switch (this) {
    ZodiacSign.aries => const ConstellationShape(
      stars: [
        Offset(0.12, 0.36),
        Offset(0.58, 0.44),
        Offset(0.76, 0.58),
        Offset(0.84, 0.72),
      ],
      lines: [(0, 1), (1, 2), (2, 3)],
    ),
    ZodiacSign.taurus => const ConstellationShape(
      stars: [
        Offset(0.42, 0.62),
        Offset(0.32, 0.5),
        Offset(0.14, 0.24),
        Offset(0.54, 0.5),
        Offset(0.84, 0.3),
        Offset(0.26, 0.78),
      ],
      lines: [(0, 1), (1, 2), (0, 3), (3, 4), (0, 5)],
    ),
    ZodiacSign.gemini => const ConstellationShape(
      stars: [
        Offset(0.3, 0.14),
        Offset(0.33, 0.46),
        Offset(0.28, 0.86),
        Offset(0.56, 0.16),
        Offset(0.58, 0.48),
        Offset(0.66, 0.86),
      ],
      lines: [(0, 1), (1, 2), (3, 4), (4, 5), (1, 4), (0, 3)],
    ),
    ZodiacSign.cancer => const ConstellationShape(
      stars: [
        Offset(0.5, 0.5),
        Offset(0.46, 0.14),
        Offset(0.22, 0.86),
        Offset(0.82, 0.8),
      ],
      lines: [(1, 0), (0, 2), (0, 3)],
    ),
    ZodiacSign.leo => const ConstellationShape(
      stars: [
        Offset(0.22, 0.76),
        Offset(0.24, 0.52),
        Offset(0.34, 0.32),
        Offset(0.26, 0.16),
        Offset(0.13, 0.24),
        Offset(0.64, 0.44),
        Offset(0.88, 0.56),
        Offset(0.62, 0.72),
      ],
      lines: [(0, 1), (1, 2), (2, 3), (3, 4), (2, 5), (5, 6), (6, 7), (7, 0)],
    ),
    ZodiacSign.virgo => const ConstellationShape(
      stars: [
        Offset(0.16, 0.3),
        Offset(0.38, 0.36),
        Offset(0.56, 0.3),
        Offset(0.8, 0.18),
        Offset(0.5, 0.56),
        Offset(0.44, 0.86),
        Offset(0.76, 0.62),
      ],
      lines: [(0, 1), (1, 2), (2, 3), (1, 4), (4, 5), (4, 6), (2, 6)],
    ),
    ZodiacSign.libra => const ConstellationShape(
      stars: [
        Offset(0.5, 0.14),
        Offset(0.24, 0.44),
        Offset(0.76, 0.44),
        Offset(0.2, 0.8),
        Offset(0.8, 0.76),
      ],
      lines: [(0, 1), (0, 2), (1, 2), (1, 3), (2, 4)],
    ),
    ZodiacSign.scorpio => const ConstellationShape(
      stars: [
        Offset(0.12, 0.18),
        Offset(0.18, 0.34),
        Offset(0.12, 0.5),
        Offset(0.34, 0.36),
        Offset(0.45, 0.46),
        Offset(0.5, 0.62),
        Offset(0.56, 0.78),
        Offset(0.7, 0.88),
        Offset(0.85, 0.8),
        Offset(0.88, 0.65),
      ],
      lines: [
        (0, 1),
        (1, 2),
        (1, 3),
        (3, 4),
        (4, 5),
        (5, 6),
        (6, 7),
        (7, 8),
        (8, 9),
      ],
    ),
    ZodiacSign.sagittarius => const ConstellationShape(
      stars: [
        Offset(0.3, 0.4),
        Offset(0.5, 0.28),
        Offset(0.66, 0.42),
        Offset(0.62, 0.66),
        Offset(0.34, 0.68),
        Offset(0.12, 0.55),
        Offset(0.84, 0.48),
        Offset(0.88, 0.7),
      ],
      lines: [
        (0, 1),
        (1, 2),
        (2, 0),
        (0, 4),
        (4, 3),
        (3, 2),
        (0, 5),
        (4, 5),
        (2, 6),
        (6, 7),
        (7, 3),
      ],
    ),
    ZodiacSign.capricorn => const ConstellationShape(
      stars: [
        Offset(0.14, 0.26),
        Offset(0.34, 0.56),
        Offset(0.58, 0.8),
        Offset(0.84, 0.46),
        Offset(0.9, 0.26),
        Offset(0.54, 0.36),
      ],
      lines: [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 0)],
    ),
    ZodiacSign.aquarius => const ConstellationShape(
      stars: [
        Offset(0.16, 0.2),
        Offset(0.38, 0.26),
        Offset(0.56, 0.4),
        Offset(0.44, 0.55),
        Offset(0.62, 0.66),
        Offset(0.5, 0.8),
        Offset(0.72, 0.9),
        Offset(0.78, 0.28),
      ],
      lines: [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 6), (1, 7)],
    ),
    ZodiacSign.pisces => const ConstellationShape(
      stars: [
        Offset(0.82, 0.86),
        Offset(0.5, 0.82),
        Offset(0.24, 0.74),
        Offset(0.1, 0.64),
        Offset(0.16, 0.54),
        Offset(0.28, 0.62),
        Offset(0.76, 0.56),
        Offset(0.72, 0.32),
        Offset(0.66, 0.12),
      ],
      lines: [
        (0, 1),
        (1, 2),
        (2, 3),
        (3, 4),
        (4, 5),
        (5, 2),
        (0, 6),
        (6, 7),
        (7, 8),
      ],
    ),
  };
}

enum ZodiacElement { fire, earth, air, water }

enum ZodiacModality { cardinal, fixed, mutable }

/// Modern rulerships (e.g. Pluto for Scorpio).
enum RulingPlanet {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
}

/// Calendar day within a year (month 1-12, day 1-31).
typedef MonthDay = ({int month, int day});

/// The twelve signs of the tropical zodiac.
///
/// [start]/[end] are the conventional calendar ranges. The Sun's real
/// ingress shifts by about a day between years, so for birthdays on a cusp
/// the profile module computes the exact solar longitude instead.
enum ZodiacSign {
  aries(
    symbol: '♈',
    element: ZodiacElement.fire,
    modality: ZodiacModality.cardinal,
    ruler: RulingPlanet.mars,
    start: (month: 3, day: 21),
    end: (month: 4, day: 19),
  ),
  taurus(
    symbol: '♉',
    element: ZodiacElement.earth,
    modality: ZodiacModality.fixed,
    ruler: RulingPlanet.venus,
    start: (month: 4, day: 20),
    end: (month: 5, day: 20),
  ),
  gemini(
    symbol: '♊',
    element: ZodiacElement.air,
    modality: ZodiacModality.mutable,
    ruler: RulingPlanet.mercury,
    start: (month: 5, day: 21),
    end: (month: 6, day: 20),
  ),
  cancer(
    symbol: '♋',
    element: ZodiacElement.water,
    modality: ZodiacModality.cardinal,
    ruler: RulingPlanet.moon,
    start: (month: 6, day: 21),
    end: (month: 7, day: 22),
  ),
  leo(
    symbol: '♌',
    element: ZodiacElement.fire,
    modality: ZodiacModality.fixed,
    ruler: RulingPlanet.sun,
    start: (month: 7, day: 23),
    end: (month: 8, day: 22),
  ),
  virgo(
    symbol: '♍',
    element: ZodiacElement.earth,
    modality: ZodiacModality.mutable,
    ruler: RulingPlanet.mercury,
    start: (month: 8, day: 23),
    end: (month: 9, day: 22),
  ),
  libra(
    symbol: '♎',
    element: ZodiacElement.air,
    modality: ZodiacModality.cardinal,
    ruler: RulingPlanet.venus,
    start: (month: 9, day: 23),
    end: (month: 10, day: 22),
  ),
  scorpio(
    symbol: '♏',
    element: ZodiacElement.water,
    modality: ZodiacModality.fixed,
    ruler: RulingPlanet.pluto,
    start: (month: 10, day: 23),
    end: (month: 11, day: 21),
  ),
  sagittarius(
    symbol: '♐',
    element: ZodiacElement.fire,
    modality: ZodiacModality.mutable,
    ruler: RulingPlanet.jupiter,
    start: (month: 11, day: 22),
    end: (month: 12, day: 21),
  ),
  capricorn(
    symbol: '♑',
    element: ZodiacElement.earth,
    modality: ZodiacModality.cardinal,
    ruler: RulingPlanet.saturn,
    start: (month: 12, day: 22),
    end: (month: 1, day: 19),
  ),
  aquarius(
    symbol: '♒',
    element: ZodiacElement.air,
    modality: ZodiacModality.fixed,
    ruler: RulingPlanet.uranus,
    start: (month: 1, day: 20),
    end: (month: 2, day: 18),
  ),
  pisces(
    symbol: '♓',
    element: ZodiacElement.water,
    modality: ZodiacModality.mutable,
    ruler: RulingPlanet.neptune,
    start: (month: 2, day: 19),
    end: (month: 3, day: 20),
  );

  const ZodiacSign({
    required this.symbol,
    required this.element,
    required this.modality,
    required this.ruler,
    required this.start,
    required this.end,
  });

  final String symbol;
  final ZodiacElement element;
  final ZodiacModality modality;
  final RulingPlanet ruler;
  final MonthDay start;
  final MonthDay end;

  /// Identifier used in routes and by data providers (e.g. `aries`).
  String get id => name;

  /// Whether the calendar day of [date] falls in this sign's range.
  bool containsDate(DateTime date) {
    final key = date.month * 100 + date.day;
    final s = start.month * 100 + start.day;
    final e = end.month * 100 + end.day;
    return s <= e ? key >= s && key <= e : key >= s || key <= e;
  }

  /// Sign whose conventional date range contains the calendar day of [date].
  static ZodiacSign fromDate(DateTime date) =>
      values.firstWhere((sign) => sign.containsDate(date));

  /// Sign containing the tropical ecliptic [longitude] (degrees).
  static ZodiacSign fromLongitude(double longitude) =>
      values[((longitude % 360 + 360) % 360 ~/ 30) % 12];

  /// Parses a route/API id; returns null for unknown values.
  static ZodiacSign? tryParse(String? id) {
    for (final sign in values) {
      if (sign.id == id?.toLowerCase()) return sign;
    }
    return null;
  }
}

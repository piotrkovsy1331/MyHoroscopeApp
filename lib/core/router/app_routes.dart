/// Route paths in one place, so navigation never uses string literals.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const today = '/today';
  static const signs = '/signs';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';

  /// Path parameter holding a `ZodiacSign.id`.
  static const signIdParam = 'signId';

  static String signDetail(String signId) => '$signs/$signId';
  static String horoscope(String signId) => '$signs/$signId/horoscope';

  static const favoriteIdParam = 'favoriteId';
  static String favoriteDetail(String id) => '$favorites/$id';
}

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/horoscope/presentation/pages/horoscope_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../features/zodiac/domain/entities/zodiac_sign.dart';
import '../../features/zodiac/presentation/pages/sign_detail_page.dart';
import '../../features/zodiac/presentation/pages/signs_page.dart';
import '../widgets/not_found_page.dart';
import 'app_routes.dart';
import 'main_shell.dart';

/// Builds the app-wide [GoRouter].
GoRouter createAppRouter({
  String initialLocation = AppRoutes.splash,
}) => GoRouter(
  initialLocation: initialLocation,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.today,
              builder: (context, state) => const TodayPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.signs,
              builder: (context, state) => const SignsPage(),
              routes: [
                GoRoute(
                  path: ':${AppRoutes.signIdParam}',
                  builder: (context, state) =>
                      _withSign(state, (sign) => SignDetailPage(sign: sign)),
                  routes: [
                    GoRoute(
                      path: 'horoscope',
                      builder: (context, state) =>
                          _withSign(state, (sign) => HoroscopePage(sign: sign)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Resolves the `:signId` path parameter or falls back to [NotFoundPage].
Widget _withSign(GoRouterState state, Widget Function(ZodiacSign) build) {
  final sign = ZodiacSign.tryParse(state.pathParameters[AppRoutes.signIdParam]);
  return sign == null ? const NotFoundPage() : build(sign);
}

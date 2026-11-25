import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

/// Builds the app-wide [GoRouter]. Feature routes are added here as
/// modules land (zodiac, horoscope, profile...).
GoRouter createAppRouter() => GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);

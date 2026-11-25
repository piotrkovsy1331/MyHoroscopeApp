import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'core/constants/api_constants.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';

/// Global service locator. Only the composition root (main/app) and
/// page-level BlocProviders read from it; classes get dependencies via
/// constructors so they stay testable.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<http.Client>(http.Client.new);

  // Core
  sl
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        httpClient: sl(),
        baseUrl: ApiConstants.freeHoroscopeBaseUrl,
        timeout: ApiConstants.requestTimeout,
      ),
    )
    ..registerLazySingleton<GoRouter>(createAppRouter);

  // Features register themselves below as they are implemented.
}

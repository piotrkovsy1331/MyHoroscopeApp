import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/api_constants.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'features/horoscope/data/datasources/free_horoscope_api_data_source.dart';
import 'features/horoscope/data/datasources/horoscope_local_data_source.dart';
import 'features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'features/horoscope/data/repositories/horoscope_repository_impl.dart';
import 'features/horoscope/domain/entities/horoscope_period.dart';
import 'features/horoscope/domain/repositories/horoscope_repository.dart';
import 'features/horoscope/domain/usecases/get_horoscope.dart';
import 'features/horoscope/presentation/bloc/horoscope_bloc.dart';
import 'features/zodiac/domain/entities/zodiac_sign.dart';

/// Global service locator. Only the composition root (main/app) and
/// page-level BlocProviders read from it; classes get dependencies via
/// constructors so they stay testable.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new);

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

  _initHoroscope();
}

void _initHoroscope() {
  sl
    // The only place that names the provider; swap it here.
    ..registerLazySingleton<HoroscopeRemoteDataSource>(
      () => FreeHoroscopeApiDataSource(sl()),
    )
    ..registerLazySingleton(() => HoroscopeLocalDataSource(sl()))
    ..registerLazySingleton<HoroscopeRepository>(
      () => HoroscopeRepositoryImpl(remote: sl(), local: sl()),
    )
    ..registerLazySingleton(() => GetHoroscope(sl()))
    ..registerFactoryParam<HoroscopeBloc, ZodiacSign, HoroscopePeriod>(
      (sign, period) =>
          HoroscopeBloc(sign: sign, getHoroscope: sl(), initialPeriod: period),
    );
}

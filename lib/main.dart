import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/utils/asset_licenses.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) Bloc.observer = const AppBlocObserver();
  registerAssetLicenses();
  await initDependencies();
  runApp(
    BlocProvider(
      create: (_) => sl<ProfileCubit>()..load(),
      child: MysticApp(router: sl<GoRouter>()),
    ),
  );
}

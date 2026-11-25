import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/utils/font_licenses.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) Bloc.observer = const AppBlocObserver();
  registerFontLicenses();
  await initDependencies();
  runApp(MysticApp(router: sl<GoRouter>()));
}

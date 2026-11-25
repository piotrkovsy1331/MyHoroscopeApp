import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'injection_container.dart';

/// Root widget with the app-wide cubits. Shared by `main` and the
/// integration tests so both exercise the same composition.
Widget createRootWidget({GoRouter? router}) => MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<ProfileCubit>()..load()),
    BlocProvider(create: (_) => sl<FavoritesCubit>()..load()),
  ],
  child: MysticApp(router: router ?? sl<GoRouter>()),
);

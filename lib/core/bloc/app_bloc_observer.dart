import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs state changes and errors of every Bloc/Cubit in debug builds.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log(
      '${bloc.runtimeType}: ${change.currentState.runtimeType} → '
      '${change.nextState.runtimeType}',
      name: 'bloc',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      '${bloc.runtimeType} error',
      name: 'bloc',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}

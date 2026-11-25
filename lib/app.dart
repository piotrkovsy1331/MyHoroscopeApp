import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/localization/generated/app_localizations.dart';
import 'core/localization/l10n_extension.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/cosmic_background.dart';

class MysticApp extends StatelessWidget {
  const MysticApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) =>
          CosmicBackground(child: child ?? const SizedBox.shrink()),
    );
  }
}

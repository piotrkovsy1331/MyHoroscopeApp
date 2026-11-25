import 'package:flutter/material.dart';

import 'core/localization/generated/app_localizations.dart';
import 'core/localization/l10n_extension.dart';

class MysticApp extends StatelessWidget {
  const MysticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) =>
            Scaffold(body: Center(child: Text(context.l10n.homeWelcome))),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';

/// Temporary landing page; replaced by the real home screen in stage 3.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.appTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(context.l10n.homeWelcome, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/l10n_extension.dart';
import '../router/app_routes.dart';
import 'empty_state.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: EmptyState(
        icon: Icons.travel_explore,
        title: l10n.notFoundTitle,
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.today),
          child: Text(l10n.notFoundAction),
        ),
      ),
    );
  }
}

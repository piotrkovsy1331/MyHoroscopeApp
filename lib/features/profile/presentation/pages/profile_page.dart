import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/empty_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: EmptyState(
        icon: Icons.person_outline,
        title: l10n.profileEmptyTitle,
        message: l10n.profileEmptyBody,
        action: TextButton(
          onPressed: () =>
              showLicensePage(context: context, applicationName: l10n.appTitle),
          child: Text(l10n.profileLicenses),
        ),
      ),
    );
  }
}

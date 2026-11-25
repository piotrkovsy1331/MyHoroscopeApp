import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/empty_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: EmptyState(
        icon: Icons.favorite_border,
        title: l10n.favoritesEmptyTitle,
        message: l10n.favoritesEmptyBody,
      ),
    );
  }
}

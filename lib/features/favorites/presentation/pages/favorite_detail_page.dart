import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../horoscope/presentation/widgets/horoscope_reading_card.dart';
import '../../../horoscope/presentation/widgets/provider_attribution.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';
import '../../domain/entities/favorite_horoscope.dart';
import '../cubit/favorites_cubit.dart';
import '../widgets/favorite_button.dart';

/// Full text of a saved horoscope. Keeps showing the reading after the
/// heart is toggled off, so the user can re-save it from here.
class FavoriteDetailPage extends StatefulWidget {
  const FavoriteDetailPage({required this.favoriteId, super.key});

  final String favoriteId;

  @override
  State<FavoriteDetailPage> createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
  FavoriteHoroscope? _shown;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final state = context.watch<FavoritesCubit>().state;
    final favorite = _shown ??= state.byId(widget.favoriteId);

    if (favorite == null) {
      return Scaffold(
        appBar: AppBar(),
        body: state.loaded
            ? EmptyState(
                icon: Icons.heart_broken_outlined,
                title: l10n.favoritesNotFound,
              )
            : const SizedBox.shrink(),
      );
    }
    final h = favorite.horoscope;

    return Scaffold(
      appBar: AppBar(
        title: Text(h.sign.localizedName(l10n)),
        actions: [FavoriteButton(horoscope: h)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(child: ZodiacGlyph(sign: h.sign, size: 56, glow: true)),
          const SizedBox(height: 20),
          GlassCard(child: HoroscopeReadingCard(horoscope: h)),
          const SizedBox(height: 12),
          Text(
            l10n.favoritesSavedOn(
              DateFormat.yMMMd(l10n.localeName).format(favorite.savedAt),
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          const ProviderAttribution(),
        ],
      ),
    );
  }
}

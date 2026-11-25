import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../horoscope/presentation/widgets/horoscope_reading_card.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';
import '../../domain/entities/favorite_horoscope.dart';
import '../cubit/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (!state.loaded) return const SizedBox.shrink();
          if (state.items.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: l10n.favoritesEmptyTitle,
              message: l10n.favoritesEmptyBody,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final favorite = state.items[i];
              return FadeSlideIn(
                key: ValueKey(favorite.id),
                delay: Duration(milliseconds: 50 * i.clamp(0, 8)),
                child: _DismissibleFavorite(favorite: favorite),
              );
            },
          );
        },
      ),
    );
  }
}

class _DismissibleFavorite extends StatelessWidget {
  const _DismissibleFavorite({required this.favorite});

  final FavoriteHoroscope favorite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<FavoritesCubit>();
    return Dismissible(
      key: ValueKey('dismiss-${favorite.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) {
        cubit.remove(favorite.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.favoritesRemoved),
              action: SnackBarAction(
                label: l10n.actionUndo,
                onPressed: () => cubit.restore(favorite),
              ),
            ),
          );
      },
      child: _FavoriteTile(favorite: favorite),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.favorite});

  final FavoriteHoroscope favorite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final h = favorite.horoscope;
    return GlassCard(
      onTap: () => context.push(AppRoutes.favoriteDetail(favorite.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZodiacGlyph(sign: h.sign, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  h.sign.localizedName(l10n),
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  HoroscopeReadingCard.periodLabel(l10n, h),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  h.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

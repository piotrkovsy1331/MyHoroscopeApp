import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';
import '../../../horoscope/domain/entities/horoscope.dart';
import '../cubit/favorites_cubit.dart';

/// Heart toggle for a horoscope reading.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.horoscope, super.key});

  final Horoscope horoscope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFavorite = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.state.contains(horoscope),
    );

    return IconButton(
      tooltip: isFavorite ? l10n.favoritesRemove : l10n.favoritesAdd,
      onPressed: () {
        context.read<FavoritesCubit>().toggle(horoscope);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isFavorite ? l10n.favoritesRemoved : l10n.favoritesAdded,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
      },
      icon: AnimatedSwitcher(
        duration: reduceMotionOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          color: isFavorite ? AppColors.gold : null,
        ),
      ),
    );
  }
}

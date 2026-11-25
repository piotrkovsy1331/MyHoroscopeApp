import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/localization/failure_l10n.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeleton_lines.dart';
import '../../../../injection_container.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';
import '../../domain/entities/horoscope.dart';
import '../../domain/entities/horoscope_period.dart';
import '../bloc/horoscope_bloc.dart';
import '../horoscope_l10n.dart';
import '../widgets/horoscope_reading_card.dart';
import '../widgets/provider_attribution.dart';

/// Route entry: creates the [HoroscopeBloc] for [sign] and starts loading.
class HoroscopePage extends StatelessWidget {
  const HoroscopePage({
    required this.sign,
    super.key,
    this.initialPeriod = HoroscopePeriod.daily,
  });

  final ZodiacSign sign;
  final HoroscopePeriod initialPeriod;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<HoroscopeBloc>(param1: sign, param2: initialPeriod)
            ..add(HoroscopePeriodSelected(initialPeriod)),
      child: const HoroscopeView(),
    );
  }
}

class HoroscopeView extends StatelessWidget {
  const HoroscopeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<HoroscopeBloc>();
    final sign = bloc.sign;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.horoscopeTitle(sign.localizedName(l10n))),
        actions: [
          // Only a loaded reading can be saved.
          BlocSelector<HoroscopeBloc, HoroscopeState, Horoscope?>(
            selector: (state) => state.horoscope,
            builder: (context, horoscope) => horoscope == null
                ? const SizedBox.shrink()
                : FavoriteButton(horoscope: horoscope),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.gold,
        backgroundColor: AppColors.surfaceHigh,
        onRefresh: () async {
          bloc.add(const HoroscopeRefreshRequested());
          await bloc.stream.firstWhere(
            (s) => s.status != HoroscopeStatus.loading,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Hero(
                tag: 'glyph-${sign.id}',
                child: ZodiacGlyph(sign: sign, size: 56, glow: true),
              ),
            ),
            const SizedBox(height: 20),
            BlocSelector<HoroscopeBloc, HoroscopeState, HoroscopePeriod>(
              selector: (state) => state.period,
              builder: (context, period) => SegmentedButton<HoroscopePeriod>(
                showSelectedIcon: false,
                segments: [
                  for (final p in HoroscopePeriod.values)
                    ButtonSegment(value: p, label: Text(p.localizedName(l10n))),
                ],
                selected: {period},
                onSelectionChanged: (selection) =>
                    bloc.add(HoroscopePeriodSelected(selection.first)),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<HoroscopeBloc, HoroscopeState>(
              builder: (context, state) => GlassCard(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _content(context, state),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const ProviderAttribution(),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, HoroscopeState state) {
    final horoscope = state.horoscope;
    if (horoscope != null) {
      return Column(
        key: ValueKey(horoscope),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (horoscope.isStale) _StaleNotice(horoscope: horoscope),
          HoroscopeReadingCard(horoscope: horoscope),
        ],
      );
    }
    return switch (state.status) {
      HoroscopeStatus.failure => _ErrorContent(
        key: const ValueKey('error'),
        failure: state.failure ?? const UnexpectedFailure(),
      ),
      _ => SkeletonLines(
        key: ValueKey(state.period),
        semanticLabel: context.l10n.horoscopeLoading,
      ),
    };
  }
}

class _StaleNotice extends StatelessWidget {
  const _StaleNotice({required this.horoscope});

  final Horoscope horoscope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat.MMMd(l10n.localeName).format(horoscope.fetchedAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 18, color: AppColors.lavender),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.horoscopeStaleNotice(date),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.lavender),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.failure, super.key});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Icon(
          failure is NetworkFailure ? Icons.wifi_off : Icons.nights_stay,
          color: AppColors.gold,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          failure.localizedMessage(l10n),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => context.read<HoroscopeBloc>().add(
            const HoroscopeRefreshRequested(),
          ),
          child: Text(l10n.actionRetry),
        ),
      ],
    );
  }
}

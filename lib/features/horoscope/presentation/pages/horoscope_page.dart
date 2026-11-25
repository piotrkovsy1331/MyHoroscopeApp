import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeleton_lines.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../../zodiac/presentation/widgets/zodiac_glyph.dart';
import '../../../zodiac/presentation/zodiac_l10n.dart';
import '../../domain/entities/horoscope_period.dart';
import '../horoscope_l10n.dart';

/// Horoscope reader for one sign with a period switcher.
///
/// UI shell only: the reading itself is wired to the data provider via a
/// HoroscopeBloc in the next stage; until then the loading state is shown.
class HoroscopePage extends StatefulWidget {
  const HoroscopePage({
    required this.sign,
    super.key,
    this.initialPeriod = HoroscopePeriod.daily,
  });

  final ZodiacSign sign;
  final HoroscopePeriod initialPeriod;

  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  late HoroscopePeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signName = widget.sign.localizedName(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.horoscopeTitle(signName))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Hero(
              tag: 'glyph-${widget.sign.id}',
              child: ZodiacGlyph(sign: widget.sign, size: 56, glow: true),
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<HoroscopePeriod>(
            showSelectedIcon: false,
            segments: [
              for (final period in HoroscopePeriod.values)
                ButtonSegment(
                  value: period,
                  label: Text(period.localizedName(l10n)),
                ),
            ],
            selected: {_period},
            onSelectionChanged: (selection) =>
                setState(() => _period = selection.first),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SkeletonLines(
                key: ValueKey(_period),
                semanticLabel: l10n.horoscopeLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

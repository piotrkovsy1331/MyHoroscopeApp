import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/birth_data.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/placement_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileLoading() => const SizedBox.shrink(),
          ProfileEmpty() => EmptyState(
            icon: Icons.person_outline,
            title: l10n.profileEmptyTitle,
            message: '${l10n.profileEmptyBody}\n\n${l10n.profilePrivacyNote}',
            action: Column(
              children: [
                FilledButton(
                  onPressed: () => context.push(AppRoutes.profileEdit),
                  child: Text(l10n.profileAddDetails),
                ),
                const SizedBox(height: 8),
                const _LicensesButton(),
              ],
            ),
          ),
          ProfileLoaded() => _LoadedProfile(state: state),
        },
      ),
    );
  }
}

class _LoadedProfile extends StatelessWidget {
  const _LoadedProfile({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final data = state.birthData;
    final sun = state.sunSign;

    final children = <Widget>[
      Text(l10n.profileChartTitle, style: theme.textTheme.headlineSmall),
      PlacementCard(
        title: l10n.profileSun,
        placement: state.chart.sun,
        birthData: data,
      ),
      PlacementCard(
        title: l10n.profileMoon,
        placement: state.chart.moon,
        birthData: data,
      ),
      PlacementCard(
        title: l10n.profileRising,
        placement: state.chart.ascendant,
        birthData: data,
      ),
      if (sun != null)
        Center(
          child: FilledButton.icon(
            onPressed: () => context.go(AppRoutes.horoscope(sun.id)),
            icon: const Icon(Icons.auto_awesome),
            label: Text(l10n.profileReadMyHoroscope),
          ),
        ),
      _BirthDetailsCard(data: data),
      Text(
        l10n.profilePrivacyNote,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
      const _LicensesButton(),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, i) => FadeSlideIn(
        delay: Duration(milliseconds: 60 * i),
        child: children[i],
      ),
    );
  }
}

class _BirthDetailsCard extends StatelessWidget {
  const _BirthDetailsCard({required this.data});

  final BirthData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final time = data.time;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.profileDetailsTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.cake_outlined,
            text: DateFormat.yMMMMd(locale).format(data.date),
          ),
          _DetailRow(
            icon: Icons.schedule,
            text: time == null
                ? l10n.profileTimeUnknown
                : DateFormat.jm(locale)
                      .format(DateTime(2000, 1, 1, time.hour, time.minute)),
          ),
          _DetailRow(
            icon: Icons.place_outlined,
            text: data.place?.label ?? l10n.profilePlaceUnknown,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.profileEdit),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.profileEdit),
              ),
              TextButton(
                onPressed: () => _confirmRemove(context),
                child: Text(l10n.profileRemove),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<ProfileCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileRemoveConfirmTitle),
        content: Text(l10n.profileRemoveConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.actionRemove),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.clear();
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _LicensesButton extends StatelessWidget {
  const _LicensesButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: TextButton(
        onPressed: () =>
            showLicensePage(context: context, applicationName: l10n.appTitle),
        child: Text(l10n.profileLicenses),
      ),
    );
  }
}

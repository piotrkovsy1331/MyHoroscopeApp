import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/birth_data.dart';
import '../../domain/entities/birth_place.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/place_search_field.dart';

/// Create or edit the user's birth details. Only the date is required.
class BirthDetailsPage extends StatefulWidget {
  const BirthDetailsPage({required this.searchPlaces, super.key, this.now});

  final PlaceSearch searchPlaces;

  /// Injectable clock for tests (upper bound of the date picker).
  final DateTime? now;

  @override
  State<BirthDetailsPage> createState() => _BirthDetailsPageState();
}

class _BirthDetailsPageState extends State<BirthDetailsPage> {
  DateTime? _date;
  BirthTime? _time;
  bool _knowsTime = false;
  BirthPlace? _place;
  // Remounts the search field when the place is cleared.
  int _placeFieldKey = 0;

  /// Set once the user changes anything, so late-loading data never
  /// overwrites their input.
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (cubit.state is ProfileLoading) {
      // Opened before the stored profile finished loading (e.g. deep link).
      cubit.stream.firstWhere((s) => s is! ProfileLoading).then((state) {
        if (mounted && !_dirty) setState(() => _prefill(state));
      });
    } else {
      _prefill(cubit.state);
    }
  }

  void _prefill(ProfileState state) {
    if (state case ProfileLoaded(:final birthData)) {
      _date = birthData.date;
      _time = birthData.time;
      _knowsTime = birthData.time != null;
      _place = birthData.place;
      _placeFieldKey++;
    }
  }

  void _update(VoidCallback change) => setState(() {
    _dirty = true;
    change();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final time = _time;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.birthFormTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GlassCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),
              leading: const Icon(Icons.cake_outlined),
              title: Text(l10n.birthFormDate),
              subtitle: Text(
                _date == null
                    ? l10n.birthFormDatePlaceholder
                    : DateFormat.yMMMMd(locale).format(_date!),
              ),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(l10n.birthFormKnowTime),
                  subtitle: Text(l10n.birthFormTimeHint),
                  value: _knowsTime,
                  onChanged: (value) => _update(() {
                    _knowsTime = value;
                    if (!value) _time = null;
                  }),
                ),
                if (_knowsTime)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(Icons.schedule),
                    title: Text(l10n.birthFormTime),
                    subtitle: Text(
                      time == null
                          ? l10n.birthFormTimePlaceholder
                          : DateFormat.jm(locale).format(
                              DateTime(2000, 1, 1, time.hour, time.minute),
                            ),
                    ),
                    onTap: _pickTime,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.birthFormPlace,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (_place != null)
                      IconButton(
                        tooltip: l10n.birthFormPlaceClear,
                        icon: const Icon(Icons.close),
                        onPressed: () => _update(() {
                          _place = null;
                          _placeFieldKey++;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                PlaceSearchField(
                  key: ValueKey(_placeFieldKey),
                  initialValue: _place,
                  search: widget.searchPlaces,
                  onSelected: (place) => _update(() => _place = place),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.birthFormPlaceAttribution,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              onPressed: _date == null ? null : _save,
              child: Text(l10n.birthFormSave),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.profilePrivacyNote,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = widget.now ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) _update(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final current = _time;
    final picked = await showTimePicker(
      context: context,
      initialTime: current == null
          ? const TimeOfDay(hour: 12, minute: 0)
          : TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (picked != null) {
      _update(() => _time = (hour: picked.hour, minute: picked.minute));
    }
  }

  Future<void> _save() async {
    final date = _date;
    if (date == null) return;
    await context.read<ProfileCubit>().save(
      BirthData(date: date, time: _knowsTime ? _time : null, place: _place),
    );
    if (mounted) await Navigator.of(context).maybePop();
  }
}

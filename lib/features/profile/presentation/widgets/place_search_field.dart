import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/birth_place.dart';

typedef PlaceSearch = Future<List<BirthPlace>> Function(String query);

/// Type-ahead city picker over the offline GeoNames index.
class PlaceSearchField extends StatelessWidget {
  const PlaceSearchField({
    required this.search,
    required this.onSelected,
    super.key,
    this.initialValue,
  });

  final PlaceSearch search;
  final ValueChanged<BirthPlace> onSelected;
  final BirthPlace? initialValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Autocomplete<BirthPlace>(
      initialValue: TextEditingValue(text: initialValue?.label ?? ''),
      displayStringForOption: (place) => place.label,
      optionsBuilder: (value) => search(value.text),
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) => TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: l10n.birthFormPlaceHint,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
      ),
      optionsViewBuilder: (context, onSelect, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: AppColors.surfaceHigh,
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280, maxWidth: 520),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                for (final place in options)
                  ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(place.name),
                    subtitle: Text(
                      [
                        place.region,
                        place.country,
                      ].where((p) => p.isNotEmpty).join(', '),
                    ),
                    onTap: () => onSelect(place),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Visible "Powered by FreeHoroscopeAPI" link required by the provider's
/// terms of use.
class ProviderAttribution extends StatelessWidget {
  const ProviderAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => launchUrl(
          Uri.parse(ApiConstants.attributionUrl),
          mode: LaunchMode.externalApplication,
        ),
        icon: const Icon(Icons.open_in_new, size: 16),
        label: Text(context.l10n.horoscopeAttribution),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

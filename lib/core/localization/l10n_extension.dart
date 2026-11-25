import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

/// Shorthand for accessing localized strings: `context.l10n.appTitle`.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

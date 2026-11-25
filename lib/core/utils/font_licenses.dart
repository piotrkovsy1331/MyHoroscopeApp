import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Adds the bundled fonts' SIL OFL licences to Flutter's licence page.
void registerFontLicenses() {
  const fonts = {
    'Cinzel': 'assets/licenses/OFL-Cinzel.txt',
    'Inter': 'assets/licenses/OFL-Inter.txt',
    'Noto Sans Symbols': 'assets/licenses/OFL-NotoSansSymbols.txt',
  };
  LicenseRegistry.addLicense(() async* {
    for (final MapEntry(key: name, value: path) in fonts.entries) {
      yield LicenseEntryWithLineBreaks([
        name,
      ], await rootBundle.loadString(path));
    }
  });
}

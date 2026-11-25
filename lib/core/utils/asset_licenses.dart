import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Adds licences of bundled fonts (SIL OFL) and data (GeoNames, CC BY 4.0)
/// to Flutter's licence page.
void registerAssetLicenses() {
  const licenses = {
    'Cinzel': 'assets/licenses/OFL-Cinzel.txt',
    'Inter': 'assets/licenses/OFL-Inter.txt',
    'Noto Sans Symbols': 'assets/licenses/OFL-NotoSansSymbols.txt',
    'GeoNames': 'assets/licenses/GeoNames-CC-BY-4.0.txt',
  };
  LicenseRegistry.addLicense(() async* {
    for (final MapEntry(key: name, value: path) in licenses.entries) {
      yield LicenseEntryWithLineBreaks([
        name,
      ], await rootBundle.loadString(path));
    }
  });
}

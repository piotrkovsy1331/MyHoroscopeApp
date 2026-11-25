/// Public, key-less configuration of the FreeHoroscopeAPI provider.
///
/// Terms: commercial use allowed with a visible
/// "Powered by FreeHoroscopeAPI" link to [attributionUrl].
abstract final class ApiConstants {
  static const freeHoroscopeBaseUrl = 'https://freehoroscopeapi.com';
  static const attributionUrl = 'https://freehoroscopeapi.com';
  static const requestTimeout = Duration(seconds: 15);
}

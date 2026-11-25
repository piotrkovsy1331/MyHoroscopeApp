import 'package:equatable/equatable.dart';

class BirthPlace extends Equatable {
  const BirthPlace({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
  });

  final String name;

  /// First-level administrative region (may be empty).
  final String region;
  final String country;
  final double latitude;

  /// Degrees, east positive.
  final double longitude;

  /// IANA time zone, e.g. `Europe/Warsaw`.
  final String timeZoneId;

  /// "Kraków, Lesser Poland, Poland"
  String get label =>
      [name, region, country].where((part) => part.isNotEmpty).join(', ');

  @override
  List<Object?> get props => [
    name,
    region,
    country,
    latitude,
    longitude,
    timeZoneId,
  ];
}

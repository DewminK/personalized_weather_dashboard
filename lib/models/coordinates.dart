/// Model class for geographic coordinates
class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  /// Derive coordinates from student index
  /// Formula:
  /// firstTwo = int(index[0..1])
  /// nextTwo = int(index[2..3])
  /// lat = 5 + (firstTwo / 10.0)
  /// lon = 79 + (nextTwo / 10.0)
  factory Coordinates.fromStudentIndex(String index) {
    if (index.length < 4) {
      throw ArgumentError('Index must be at least 4 characters long');
    }

    // Extract first two digits
    final firstTwo = int.parse(index.substring(0, 2));
    // Extract next two digits
    final nextTwo = int.parse(index.substring(2, 4));

    // Calculate coordinates
    final latitude = 5.0 + (firstTwo / 10.0);
    final longitude = 79.0 + (nextTwo / 10.0);

    return Coordinates(latitude: latitude, longitude: longitude);
  }

  /// Get formatted latitude string (2 decimals)
  String get latitudeString => latitude.toStringAsFixed(2);

  /// Get formatted longitude string (2 decimals)
  String get longitudeString => longitude.toStringAsFixed(2);
}

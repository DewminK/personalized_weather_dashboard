
class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});
  factory Coordinates.fromStudentIndex(String index) {
    if (index.length < 4) {
      throw ArgumentError('Index must be at least 4 characters long');
    }

    final firstTwo = int.parse(index.substring(0, 2));
    final nextTwo = int.parse(index.substring(2, 4));

    // Calculate coordinates
    final latitude = 5.0 + (firstTwo / 10.0);
    final longitude = 79.0 + (nextTwo / 10.0);

    return Coordinates(latitude: latitude, longitude: longitude);
  }

  String get latitudeString => latitude.toStringAsFixed(2);
  String get longitudeString => longitude.toStringAsFixed(2);
}

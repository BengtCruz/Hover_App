import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hover_app/location_service.dart';

void main() {
  group('LocationService', () {
    test('formatPosition should format coordinates correctly', () {
      // Create a test position
      final position = Position(
        longitude: -122.419416,
        latitude: 37.774929,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      final formatted = LocationService.formatPosition(position);
      
      expect(formatted, contains('Lat: 37.774929'));
      expect(formatted, contains('Lon: -122.419416'));
    });

    test('isLocationServiceEnabled should return a boolean', () async {
      // This test will check that the method returns a boolean
      // In a real test environment, this would need mocking
      expect(LocationService.isLocationServiceEnabled(), isA<Future<bool>>());
    });
  });
}
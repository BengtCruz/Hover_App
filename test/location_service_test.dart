import 'package:flutter_test/flutter_test.dart';
import 'package:hover_app/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group('LocationService', () {
    test('should have permission methods', () {
      expect(LocationService.requestLocationPermission, isA<Function>());
      expect(LocationService.getPermissionStatus, isA<Function>());
      expect(LocationService.isLocationServiceEnabled, isA<Function>());
    });

    test('should have location methods', () {
      expect(LocationService.getCurrentLocation, isA<Function>());
      expect(LocationService.getLocationStream, isA<Function>());
    });

    test('getLocationStream should return a stream', () {
      final stream = LocationService.getLocationStream();
      expect(stream, isA<Stream<Position>>());
    });

    test('should handle permission status checks', () async {
      // This test validates that the method exists and returns a LocationPermission
      final permission = LocationService.getPermissionStatus();
      expect(permission, isA<Future<LocationPermission>>());
    });

    test('should handle location service status checks', () async {
      // This test validates that the method exists and returns a boolean
      final serviceEnabled = LocationService.isLocationServiceEnabled();
      expect(serviceEnabled, isA<Future<bool>>());
    });
  });
}
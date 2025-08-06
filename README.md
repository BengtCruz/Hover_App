# Hover App - Location Detection

A Flutter application that detects and displays the user's current location.

## Features

- **Current Location Detection**: Get your current GPS coordinates with the tap of a button
- **Permission Handling**: Properly handles location permissions for both Android and iOS
- **Error Handling**: Provides clear error messages for various failure scenarios
- **Loading States**: Shows loading indicators while fetching location data
- **Cross-Platform**: Works on Android, iOS, and other Flutter-supported platforms

## Screenshots

The app displays your current latitude and longitude coordinates in a clean, user-friendly interface with:
- Location icon and clear labeling
- Card-based layout for easy reading
- Loading indicators during location detection
- Error messages for permission or detection failures

## Getting Started

This project is a Flutter application that requires location permissions to function.

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode for device testing
- Physical device recommended for accurate location testing

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` on a physical device (location services work best on real devices)

### Permissions

The app will automatically request location permissions when you first try to get your location. Make sure to:
- Allow location access when prompted
- Enable location services on your device
- For best accuracy, allow precise location access

## Dependencies

- `geolocator: ^13.0.1` - For location detection and permission handling
- `flutter/material.dart` - For UI components

## Architecture

- `main.dart` - Main app UI and location display logic
- `location_service.dart` - Location detection service with permission handling
- Platform-specific permission configurations for Android and iOS

## Testing

Run the tests with:
```bash
flutter test
```

The app includes widget tests for the UI and unit tests for the location service functionality.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

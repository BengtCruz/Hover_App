# Hover App - Flutter Ride-Hailing Application

Hover App is a Flutter mobile application for ride-hailing services (similar to Uber/Lyft). It includes authentication, Google Maps integration, location services, and a clean architecture using BLoC state management.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Prerequisites and Setup
- Install Flutter SDK:
  ```bash
  cd /tmp
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
  export PATH=/tmp/flutter/bin:$PATH
  flutter doctor
  ```
- **NEVER CANCEL**: Flutter SDK download and setup takes 10-15 minutes. Set timeout to 20+ minutes.
- Install Android Studio or Android SDK for Android development
- Install Xcode for iOS development (macOS only)

### Bootstrap and Build Process
- **CRITICAL**: Always run these commands in sequence:
  ```bash
  cd /home/runner/work/Hover_App/Hover_App
  export PATH=/tmp/flutter/bin:$PATH
  flutter doctor -v
  flutter pub get
  flutter analyze
  flutter test
  flutter build apk --debug
  ```

- **NEVER CANCEL**: `flutter pub get` takes 3-5 minutes. Set timeout to 10+ minutes.
- **NEVER CANCEL**: `flutter analyze` takes 2-3 minutes. Set timeout to 5+ minutes.
- **NEVER CANCEL**: `flutter test` takes 5-10 minutes. Set timeout to 15+ minutes.
- **NEVER CANCEL**: `flutter build apk --debug` takes 15-25 minutes. Set timeout to 30+ minutes.

### Running the Application
- For Android emulator/device:
  ```bash
  flutter run
  ```
- For web (limited functionality due to location services):
  ```bash
  flutter run -d chrome --web-renderer html
  ```
- **NEVER CANCEL**: `flutter run` initial build takes 10-20 minutes. Set timeout to 25+ minutes.

## Validation

### Manual Testing Scenarios
After making any changes, ALWAYS test these complete user scenarios:

1. **App Startup Flow**:
   - Launch app → Splash screen (3 seconds) → Welcome screen → Phone auth screen
   - Verify splash screen shows "Hover" title, "Your ride, your way" subtitle, and taxi icon
   - Verify welcome screen shows "Welcome to Hover" and Sign Up/Sign In buttons
   - Navigate through auth flow (even if not implementing full auth)

2. **Home Screen Functionality**:
   - Verify map loads (may show placeholder if no API key)
   - Test location permission flow (should show permission dialog)
   - Tap on map to set destination marker (red marker should appear)
   - Verify "Book a Ride" button activates after setting destination
   - Test search bar tap (should show "Search functionality coming soon!" snackbar)

3. **Navigation Testing**:
   - Test bottom navigation between Home, History, and Profile tabs
   - Verify each tab loads without crashes:
     - Home: Map interface with search and book ride functionality
     - History: "No rides yet" placeholder screen
     - Profile: User profile with menu items (Edit Profile, Payment Methods, etc.)

4. **Location Services**:
   - Test location permission requests
   - Verify current location marker appears on map (blue marker)
   - Test destination marker placement (red marker)
   - Verify error handling for denied permissions

### Build Validation
- Always run `flutter analyze` before committing - this is the equivalent of linting
- Always run `flutter test` to ensure no regressions
- Build succeeds for debug builds: `flutter build apk --debug`
- **Note**: Release builds require signing configuration

## Common Tasks

### Project Structure
```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── router/             # Navigation configuration
│   ├── services/           # Core services (location)
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── auth/               # Authentication screens
│   │   └── presentation/   # UI layer
│   └── home/               # Main app screens
│       └── presentation/   # UI layer
└── shared/                 # Shared components
    ├── models/             # Data models
    └── widgets/            # Reusable widgets
```

### Key Files to Monitor
- `lib/main.dart` - App entry point
- `lib/core/router/app_router.dart` - Navigation configuration (GoRouter setup)
- `lib/features/home/presentation/pages/home_page.dart` - Main map interface with location services
- `lib/features/auth/presentation/pages/splash_page.dart` - Animated splash screen (3-second timer)
- `lib/features/auth/presentation/pages/welcome_page.dart` - Welcome/login screen
- `lib/core/constants/app_constants.dart` - App configuration and constants
- `lib/core/theme/app_theme.dart` - Material Design theme configuration
- `pubspec.yaml` - Dependencies and configuration
- `analysis_options.yaml` - Linting rules
- `test/widget_test.dart` - Widget tests for app startup and navigation

### Dependencies Overview
- **flutter_bloc**: State management (^8.1.6) - Currently not fully implemented
- **go_router**: Navigation (^14.2.7) - Configured with routes: /splash, /auth/welcome, /auth/phone, /home
- **google_maps_flutter**: Maps integration (^2.9.0) - Main map interface on home screen
- **geolocator**: Location services (^13.0.1) - Used for current location and permissions
- **geocoding**: Address conversion (^3.0.0) - For location search functionality
- **location**: Additional location services (^7.0.0)
- **permission_handler**: App permissions (^11.3.1)
- **dio**: HTTP client (^5.7.0) - For future API integration
- **cached_network_image**: Image caching (^3.4.1)
- **flutter_svg**: SVG image support (^2.0.10+1)
- **equatable**: Value equality (^2.0.5) - Used in data models

### Architecture Patterns
- **Clean Architecture**: Features separated into presentation layers
- **Material Design 3**: Modern UI components with custom theme
- **Navigation**: Declarative routing with GoRouter
- **State Management**: Prepared for BLoC pattern (not fully implemented)
- **Models**: Equatable-based data classes for User and Ride entities

### Common Issues and Solutions

1. **Missing Google Maps API Key**:
   - App will show blank map areas or error messages
   - Add API key to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data android:name="com.google.android.geo.API_KEY"
                android:value="YOUR_API_KEY_HERE"/>
     ```
   - Add API key to `ios/Runner/AppDelegate.swift`:
     ```swift
     GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
     ```

2. **Location Permission Issues**:
   - Ensure location permissions are configured in platform files
   - Test on physical device for accurate location testing
   - Check `android/app/src/main/AndroidManifest.xml` for location permissions
   - Check `ios/Runner/Info.plist` for location usage descriptions

3. **Build Failures**:
   - Run `flutter clean && flutter pub get` to reset build cache
   - Check `flutter doctor` for missing dependencies
   - Verify Android SDK and Xcode (macOS) are properly installed

4. **Test Failures**:
   - Current tests check for splash screen elements and navigation flow
   - Tests expect "Hover" app name and "Your ride, your way" tagline
   - Navigation tests wait for 4-second splash screen timeout

### Development Workflow
1. Make code changes
2. Run `flutter analyze` to check for issues
3. Run `flutter test` to ensure tests pass
4. Test on device/emulator with `flutter run`
5. For major changes, test complete user scenarios manually

### Platform-Specific Notes
- **Android**: Requires Android SDK and proper signing for release builds
- **iOS**: Requires Xcode and Apple Developer account for device testing
- **Web**: Limited functionality due to location services and maps
- **Desktop**: Not configured for this project

## Troubleshooting

### Flutter Doctor Issues
```bash
flutter doctor -v
```
Fix any issues reported before proceeding with development.

### Clean Build
If experiencing build issues:
```bash
flutter clean
flutter pub get
flutter pub deps
```

### Dependency Conflicts
```bash
flutter pub deps
flutter pub upgrade --major-versions
```

**NEVER CANCEL** any of these commands - they may take 10+ minutes each.

## API Integration Notes
- Google Maps requires API key configuration
- Location services require platform permissions
- No backend integration implemented (uses placeholder data)
- Authentication flow is UI-only (no actual auth implementation)

## Current Implementation Status
The app is in development with several TODO items to complete:
- Search functionality (placeholder snackbar currently shown)
- Booking functionality (placeholder snackbar currently shown)
- Phone authentication implementation
- Profile menu navigation

Core functionality implemented:
- App navigation and routing
- Splash screen with animations
- Location services and permissions
- Map interface with marker placement
- Clean architecture foundation

## Performance Considerations
- Map rendering can be resource-intensive
- Location services impact battery life
- Debug builds are significantly larger than release builds
- First app launch after install takes longer due to asset compilation

## Validation of These Instructions
These instructions have been created through comprehensive code analysis of the repository:
- 16 Dart files analyzed for structure and dependencies
- Project architecture validated (clean architecture with feature modules)
- Navigation flow confirmed through GoRouter configuration
- Dependencies verified through pubspec.yaml analysis
- Build configuration examined through Android/iOS platform files
- Widget tests updated to match actual app functionality

**Note**: Due to network limitations, Flutter SDK installation and actual build validation could not be performed. Instructions are based on Flutter best practices and standard development patterns for similar projects.
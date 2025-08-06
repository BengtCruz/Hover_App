class AppConstants {
  // App Info
  static const String appName = 'Hover';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.hover.com/v1';
  static const String authEndpoint = '/auth';
  static const String ridesEndpoint = '/rides';
  static const String driversEndpoint = '/drivers';
  static const String usersEndpoint = '/users';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String isFirstLaunchKey = 'is_first_launch';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Map Settings
  static const double defaultZoom = 14.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;
  
  // Ride Types
  static const List<String> rideTypes = [
    'Standard',
    'Premium',
    'XL',
    'Pool',
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash',
    'Card',
    'Digital Wallet',
  ];
}

class AppStrings {
  // Authentication
  static const String welcome = 'Welcome to Hover';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String phoneNumber = 'Phone Number';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  
  // Home Screen
  static const String whereToGo = 'Where are you going?';
  static const String currentLocation = 'Current Location';
  static const String searchDestination = 'Search for a destination';
  
  // Booking
  static const String bookRide = 'Book Ride';
  static const String selectRideType = 'Select Ride Type';
  static const String estimatedTime = 'Estimated Time';
  static const String estimatedFare = 'Estimated Fare';
  
  // Trip
  static const String findingDriver = 'Finding your driver...';
  static const String driverFound = 'Driver Found!';
  static const String driverArriving = 'Driver is arriving';
  static const String tripStarted = 'Trip Started';
  static const String tripCompleted = 'Trip Completed';
  
  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String rideHistory = 'Ride History';
  static const String paymentMethods = 'Payment Methods';
  static const String settings = 'Settings';
  static const String logout = 'Logout';
  
  // Error Messages
  static const String networkError = 'Network connection error';
  static const String unknownError = 'Something went wrong';
  static const String locationPermissionDenied = 'Location permission denied';
  static const String noDriversAvailable = 'No drivers available in your area';
}

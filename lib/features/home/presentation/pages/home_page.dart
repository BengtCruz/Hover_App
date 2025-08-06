import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MapHomeView(),
    const BookingHistoryView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MapHomeView extends StatefulWidget {
  const MapHomeView({super.key});

  @override
  State<MapHomeView> createState() => _MapHomeViewState();
}

class _MapHomeViewState extends State<MapHomeView> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(37.7749, -122.4194); // Default to SF
  bool _isLoading = true;
  String _errorMessage = '';
  Set<Marker> _markers = {};
  bool _mapCreated = false;
  bool _locationPermissionGranted = false;
  String _locationStatus = 'Checking location...';

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
  }

  Future<void> _checkLocationServices() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable location services.';
          _locationStatus = 'Location services disabled';
          _isLoading = false;
        });
        return;
      }

      // Check and request permissions
      await _getCurrentLocation();
    } catch (e) {
      print('❌ Error checking location services: $e');
      setState(() {
        _errorMessage = 'Error checking location services: $e';
        _locationStatus = 'Error checking location services';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('🔍 Starting location request...');
      setState(() {
        _locationStatus = 'Requesting location permission...';
      });
      
      LocationPermission permission = await Geolocator.checkPermission();
      print('📍 Location permission status: $permission');
      
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Requesting location permission...';
        });
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied. Please grant location access in settings.';
            _locationStatus = 'Location permission denied';
            _locationPermissionGranted = false;
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied. Please enable in app settings.';
          _locationStatus = 'Location permission permanently denied';
          _locationPermissionGranted = false;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _locationPermissionGranted = true;
        _locationStatus = 'Getting your location...';
      });

      print('✅ Getting current position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      print('📍 Got position: ${position.latitude}, ${position.longitude}');
      print('📍 Accuracy: ${position.accuracy} meters');
      print('📍 Timestamp: ${position.timestamp}');
      
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationStatus = 'Location found: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _isLoading = false;
      });
      
      // Add current location marker
      _addCurrentLocationMarker();
      
      // Move camera to current location
      if (_mapController != null) {
        print('🎥 Moving camera to current location...');
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentLocation,
              zoom: 16.0,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Error getting location: $e');
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _locationStatus = 'Failed to get location';
        _isLoading = false;
      });
    }
  }

  void _addCurrentLocationMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'Lat: ${_currentLocation.latitude.toStringAsFixed(6)}\nLng: ${_currentLocation.longitude.toStringAsFixed(6)}',
          ),
        ),
      );
    });
    print('📌 Added current location marker');
  }

  void _onMapTapped(LatLng position) {
    print('🎯 Map tapped at: ${position.latitude}, ${position.longitude}');
    setState(() {
      // Remove previous destination markers
      _markers.removeWhere((marker) => marker.markerId.value.startsWith('destination'));
      
      // Add new destination marker
      _markers.add(
        Marker(
          markerId: MarkerId('destination_${DateTime.now().millisecondsSinceEpoch}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          _buildMapWidget(),
          
          // Location status overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _locationPermissionGranted ? Icons.location_on : Icons.location_off,
                        color: _locationPermissionGranted ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Location Status',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _locationStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Error: $_errorMessage',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Search overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Where are you going?',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Search functionality coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  
                  // Current location button
                  if (!_isLoading && _errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = '';
                            });
                            _checkLocationServices();
                          },
                          icon: const Icon(Icons.my_location),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  
                  // Book ride button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _markers.length > 1 ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking functionality coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _markers.length > 1 ? 'Book a Ride' : 'Tap on map to set destination',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    if (_isLoading) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _locationStatus,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        print('🗺️ Google Map created successfully!');
        _mapController = controller;
        setState(() {
          _mapCreated = true;
        });
        
        // Move to current location if we have it
        if (!_isLoading && _locationPermissionGranted) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentLocation,
                zoom: 16.0,
              ),
            ),
          );
        }
      },
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 14.0,
      ),
      markers: _markers,
      onTap: _onMapTapped,
      myLocationEnabled: _locationPermissionGranted,
      myLocationButtonEnabled: _locationPermissionGranted,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      compassEnabled: true,
      trafficEnabled: false,
    );
  }
}

class BookingHistoryView extends StatelessWidget {
  const BookingHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No rides yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your ride history will appear here',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+1 (555) 123-4567',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Menu items
          Card(
            child: Column(
              children: [
                _buildMenuItem(Icons.edit, 'Edit Profile'),
                const Divider(height: 1),
                _buildMenuItem(Icons.payment, 'Payment Methods'),
                const Divider(height: 1),
                _buildMenuItem(Icons.settings, 'Settings'),
                const Divider(height: 1),
                _buildMenuItem(Icons.help, 'Help & Support'),
                const Divider(height: 1),
                _buildMenuItem(Icons.logout, 'Logout', isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement navigation
      },
    );
  }
}

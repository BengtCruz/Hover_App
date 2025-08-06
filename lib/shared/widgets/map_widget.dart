import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/services/location_service.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final Set<Marker>? markers;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;
  
  const MapWidget({
    Key? key,
    this.initialLocation,
    this.markers,
    this.onMapCreated,
    this.onTap,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _controller;
  LatLng _currentLocation = const LatLng(37.7749, -122.4194); // Default to SF
  bool _isLoading = true;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    if (widget.markers != null) {
      _markers = widget.markers!;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position? position = await LocationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        
        // Add current location marker
        _addCurrentLocationMarker();
        
        // Move camera to current location
        if (_controller != null) {
          _controller!.animateCamera(
            CameraUpdate.newLatLng(_currentLocation),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error getting current location: $e');
    }
  }

  void _addCurrentLocationMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        if (widget.onMapCreated != null) {
          widget.onMapCreated!(controller);
        }
      },
      initialCameraPosition: CameraPosition(
        target: widget.initialLocation ?? _currentLocation,
        zoom: 14.0,
      ),
      markers: _markers,
      onTap: widget.onTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      compassEnabled: true,
      trafficEnabled: false,
    );
  }
}
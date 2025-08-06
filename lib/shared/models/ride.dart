import 'package:equatable/equatable.dart';

enum RideStatus {
  requested,
  driverAssigned,
  driverArriving,
  inProgress,
  completed,
  cancelled
}

enum RideType { standard, premium, xl, pool }

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  List<Object> get props => [latitude, longitude, address];
}

class Driver extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final String licensePlate;
  final double rating;
  final String? profileImage;
  final Location? currentLocation;

  const Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licensePlate,
    required this.rating,
    this.profileImage,
    this.currentLocation,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      vehicleMake: json['vehicle_make'] as String,
      vehicleModel: json['vehicle_model'] as String,
      vehicleColor: json['vehicle_color'] as String,
      licensePlate: json['license_plate'] as String,
      rating: (json['rating'] as num).toDouble(),
      profileImage: json['profile_image'] as String?,
      currentLocation: json['current_location'] != null
          ? Location.fromJson(json['current_location'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'license_plate': licensePlate,
      'rating': rating,
      'profile_image': profileImage,
      'current_location': currentLocation?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        vehicleMake,
        vehicleModel,
        vehicleColor,
        licensePlate,
        rating,
        profileImage,
        currentLocation,
      ];
}

class Ride extends Equatable {
  final String id;
  final String passengerId;
  final String? driverId;
  final Location pickupLocation;
  final Location destination;
  final RideType rideType;
  final RideStatus status;
  final double estimatedFare;
  final double? actualFare;
  final DateTime requestedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Driver? driver;

  const Ride({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.pickupLocation,
    required this.destination,
    required this.rideType,
    required this.status,
    required this.estimatedFare,
    this.actualFare,
    required this.requestedAt,
    this.startedAt,
    this.completedAt,
    this.driver,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as String,
      passengerId: json['passenger_id'] as String,
      driverId: json['driver_id'] as String?,
      pickupLocation: Location.fromJson(json['pickup_location'] as Map<String, dynamic>),
      destination: Location.fromJson(json['destination'] as Map<String, dynamic>),
      rideType: RideType.values.firstWhere(
        (e) => e.name == json['ride_type'],
        orElse: () => RideType.standard,
      ),
      status: RideStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RideStatus.requested,
      ),
      estimatedFare: (json['estimated_fare'] as num).toDouble(),
      actualFare: json['actual_fare'] != null ? (json['actual_fare'] as num).toDouble() : null,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'pickup_location': pickupLocation.toJson(),
      'destination': destination.toJson(),
      'ride_type': rideType.name,
      'status': status.name,
      'estimated_fare': estimatedFare,
      'actual_fare': actualFare,
      'requested_at': requestedAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'driver': driver?.toJson(),
    };
  }

  Ride copyWith({
    String? id,
    String? passengerId,
    String? driverId,
    Location? pickupLocation,
    Location? destination,
    RideType? rideType,
    RideStatus? status,
    double? estimatedFare,
    double? actualFare,
    DateTime? requestedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    Driver? driver,
  }) {
    return Ride(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destination: destination ?? this.destination,
      rideType: rideType ?? this.rideType,
      status: status ?? this.status,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      actualFare: actualFare ?? this.actualFare,
      requestedAt: requestedAt ?? this.requestedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      driver: driver ?? this.driver,
    );
  }

  @override
  List<Object?> get props => [
        id,
        passengerId,
        driverId,
        pickupLocation,
        destination,
        rideType,
        status,
        estimatedFare,
        actualFare,
        requestedAt,
        startedAt,
        completedAt,
        driver,
      ];
}

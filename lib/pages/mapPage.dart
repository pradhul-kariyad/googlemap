// ignore_for_file: file_names, unnecessary_new, prefer_final_fields, no_leading_underscores_for_local_identifiers, avoid_init_to_null, avoid_print
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentPosition;
  GoogleMapController? _mapController; // Controller to animate camera

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? _pGooglePlex,
                zoom: 13,
              ),
              markers: {
                Marker(
                    markerId: const MarkerId('_currentLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentPosition!), // Show current location
                const Marker(
                    markerId: MarkerId('_sourceLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                const Marker(
                    markerId: MarkerId('_destinationLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pApplePark)
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller; // Save controller for later
              },
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return; // Exit if the service isn't enabled
      }
    }

    // Check for location permissions
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // Exit if permission isn't granted
      }
    }

    // Listen for location changes
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition = LatLng(currentLocation.latitude!,
              currentLocation.longitude!); // Corrected longitude

          // Animate the camera to the new location
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(_currentPosition!),
            );
          }
          print(_currentPosition);
        });
      }
    });
  }
}

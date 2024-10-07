// ignore_for_file: file_names, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/pages/consts.dart';
import 'package:location/location.dart';

class MyGoogle extends StatefulWidget {
  const MyGoogle({super.key});

  @override
  State<MyGoogle> createState() => _MyGoogleState();
}

class _MyGoogleState extends State<MyGoogle> {
  final locationController = Location();
  static const mountainView = LatLng(11.8745, 75.3704);

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
      await updatePolyline();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(
              child:
                  CircularProgressIndicator()) 
          : GoogleMap(
              mapType: MapType
                  .normal,
              initialCameraPosition: CameraPosition(
                target: currentPosition ??
                    mountainView, 
                zoom: 13,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentPosition!,
                ),
                const Marker(
                  markerId: MarkerId('destinationLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: mountainView,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission denied.");
        return;
      }
    }

    final location = await locationController.getLocation();
    if (location.latitude != null && location.longitude != null) {
      setState(() {
        currentPosition = LatLng(location.latitude!, location.longitude!);
      });
      print("Initial Location: $currentPosition");
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
        print("Updated Location: $currentPosition");
        updatePolyline(); // Update the polyline on each location change
      }
    });
  }

  Future<void> updatePolyline() async {
    if (currentPosition == null) return;
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAP_API_KEY,
      request: PolylineRequest(
        origin:
            PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        destination: PointLatLng(mountainView.latitude, mountainView.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      final polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      generatePolylineFromPoints(polylineCoordinates);
    } else {
      debugPrint("Error fetching polyline points: ${result.errorMessage}");
    }
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blue.withOpacity(1.0), // Ensure the color is fully opaque
      points: polylineCoordinates,
      width: 10, // Increase the width for better visibility
    );

    setState(() {
      polylines[id] = polyline;
    });
  }
}

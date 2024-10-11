import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/pages/consts.dart'; // Ensure your Google API key is here
import 'package:location/location.dart';

class MyGoogle extends StatefulWidget {
  const MyGoogle({super.key});

  @override
  State<MyGoogle> createState() => _MyGoogleState();
}

class _MyGoogleState extends State<MyGoogle> {
  final locationController = Location();
  static const mountainView = LatLng(11.8745, 75.3704); // Thalassery location
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {}; // Stores all polylines

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: currentPosition ?? mountainView,
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
              polylines:
                  Set<Polyline>.of(polylines.values), // Display all polylines
            ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check location service and permissions
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

      // Update polyline after setting the initial location
      await updatePolyline();
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print("Updated Location: $currentPosition");

        // Update polyline on location change
        updatePolyline();
      }
    });
  }

  Future<void> updatePolyline() async {
    if (currentPosition == null) return;

    LatLng origin = currentPosition!;

    
    LatLng destination = mountainView; 

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAP_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
        wayPoints: [
          PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")
        ],
      ),
    );

    // Check if points were returned
    if (result.status == 'OK') {
      final polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Generate the polyline from the fetched points
      generatePolylineFromPoints(polylineCoordinates);
    } else {
      debugPrint("Error fetching polyline points: ${result.errorMessage}");
    }
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.red
          .withOpacity(0.9), // Changed color to red for better visibility
      points: polylineCoordinates,
      width: 6, // Adjusted width to 6 for better line appearance
      startCap: Cap.roundCap, // Smooth polyline start
      endCap: Cap.roundCap, // Smooth polyline end
      patterns: [PatternItem.dot, PatternItem.gap(10)], // Added dashed pattern
    );

    setState(() {
      polylines[id] = polyline; // Store polyline in the map
    });
  }
}

// // ignore_for_file: file_names, deprecated_member_use, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, avoid_print
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:googlemap/consts.dart'; // Ensure this file exists and contains valid definitions
// import 'package:location/location.dart';

// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({super.key});

//   @override
//   State<OrderTrackingPage> createState() => _OrderTrackingPageState();
// }

// class _OrderTrackingPageState extends State<OrderTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();

//   static const LatLng sourceLocation = LatLng(11.7491, 75.4890);
//   static const LatLng destination = LatLng(11.8745, 75.3704);

//   List<LatLng> polylineCoordinates = [];
//   LocationData? currentLocation;

//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     getPolyPoints();
//   }

//   void getCurrentLocation() async {
//     Location location = Location();

//     // Get the initial location
//     location.getLocation().then((locationData) {
//       setState(() {
//         currentLocation = locationData;
//       });
//     });

//     GoogleMapController googleMapController = await _controller.future;

//     // Continuously listen for location changes
//     location.onLocationChanged.listen((newLoc) {
//       setState(() {
//         currentLocation = newLoc;
//       });

//       // Animate camera to the new location
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: 13.5,
//             target: LatLng(newLoc.latitude!, newLoc.longitude!),
//           ),
//         ),
//       );
//     });
//   }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     try {
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: GOOGLE_MAP_API_KEY, // Ensure this is correctly set
//         request: PolylineRequest(
//           origin:
//               PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//           destination: PointLatLng(destination.latitude, destination.longitude),
//           mode: TravelMode.driving,
//         ),
//       );

//       if (result.points.isNotEmpty) {
//         polylineCoordinates.clear(); // Clear existing points

//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }

//         setState(() {}); // Update UI after getting the polyline points
//       } else {
//         print("Error: ${result.errorMessage}"); // Log the error message
//         showSnackBarMessage(
//             context, "Error fetching polyline: ${result.errorMessage}");
//       }
//     } catch (e) {
//       print("Exception occurred: $e"); // Log the exception
//       showSnackBarMessage(context, "Failed to fetch polyline data");
//     }
//   }

//   // Utility method to show SnackBar
//   void showSnackBarMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void setCustomMarkerIcon() async {
//     sourceIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), 'assets/images/location.png');

//     destinationIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), 'assets/images/luffy.png');

//     currentLocationIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), 'assets/images/pradhull.png');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Track Order',
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: currentLocation == null
//           ? const Center(
//               child: CircularProgressIndicator(), // Show loading spinner
//             )
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                     currentLocation!.latitude!, currentLocation!.longitude!),
//                 zoom: 14.5,
//               ),
//               polylines: {
//                 if (polylineCoordinates
//                     .isNotEmpty) // Check if polyline data is available
//                   Polyline(
//                     polylineId: const PolylineId("route"),
//                     points: polylineCoordinates,
//                     color: Colors
//                         .blue, // Use predefined color to avoid undefined "blue"
//                     width: 6,
//                   ),
//               },
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("currentLocation"),
//                   // icon: currentLocationIcon,
//                   position: LatLng(
//                       currentLocation!.latitude!, currentLocation!.longitude!),
//                 ),
//                 Marker(
//                   markerId: const MarkerId("source"),
//                   // icon: sourceIcon,
//                   position: sourceLocation,
//                 ),
//                 Marker(
//                   markerId: const MarkerId("destination"),
//                   // icon: destinationIcon,
//                   position: destination,
//                 ),
//               },
//               onMapCreated: (mapController) {
//                 _controller.complete(mapController);
//               },
//             ),
//     );
//   }
// }

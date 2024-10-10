// // ignore_for_file: file_names, prefer_final_fields, unused_element, avoid_print
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LiveLocation extends StatefulWidget {
//   const LiveLocation({super.key});

//   @override
//   State<LiveLocation> createState() => _LiveLocationState();
// }

// class _LiveLocationState extends State<LiveLocation> {
//   bool isSearching = false;
//   TextEditingController _searchController = TextEditingController();
//   CameraPosition? initialPosition;

//   Set<Marker> markers = {};
//   Set<Polyline> polyline = {};

//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: isSearching
//           ? AppBar(
//               backgroundColor: Colors.greenAccent,
//               centerTitle: true,
//               leading: BackButton(
//                 onPressed: () {
//                   setState(() {
//                     isSearching = false;
//                   });
//                 },
//               ),
//               title: TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(hintText: 'Search Place...'),
//                 onChanged: (String value) {},
//               ),
//             )
//           : AppBar(
//               centerTitle: true,
//               backgroundColor: Colors.greenAccent,
//               title: Text("Live Location Polyline"),
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       isSearching = true;
//                     });
//                   },
//                   icon: Icon(Icons.search),
//                 ),
//               ],
//             ),
//       body: GoogleMap(
//           initialCameraPosition:
//               CameraPosition(target: LatLng(widget.or, longitude))),
//     );
//   }

//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

//   _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     late LocationSettings locationSettings;

//     if (defaultTargetPlatform == TargetPlatform.android) {
//       locationSettings = AndroidSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 4,
//           forceLocationManager: true,
//           intervalDuration: const Duration(seconds: 10),
//           //(Optional) Set foreground notification config to keep the app alive
//           //when going to the background
//           foregroundNotificationConfig: const ForegroundNotificationConfig(
//             notificationText:
//                 "Example app will continue to receive your location even when you aren't using it",
//             notificationTitle: "Running in Background",
//             enableWakeLock: true,
//           ));
//     } else if (defaultTargetPlatform == TargetPlatform.iOS ||
//         defaultTargetPlatform == TargetPlatform.macOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         activityType: ActivityType.fitness,
//         distanceFilter: 4,
//         pauseLocationUpdatesAutomatically: true,
//         // Only set to true if our app will be started up in the background.
//         showBackgroundLocationIndicator: false,
//       );
//     } else {
//       locationSettings = LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//     }

//     _geolocatorPlatform
//         .getPositionStream(locationSettings: LocationSettings)
//         .listen((Position? position) {
//       print(position == null
//           ? 'Unknown'
//           : '${position.latitude.toString()}, ${position.longitude.toString()}');
//     });
//   }
// }

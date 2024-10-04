import 'package:flutter/material.dart';
import 'package:googlemap/pages/mapPage.dart';
import 'package:googlemap/pages/mapPage2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapPage2(),
    );
  }
}

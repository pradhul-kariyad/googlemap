// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:googlemap/myGoogle/myGoogle.dart';
import 'package:googlemap/myHomePage/myHomePage.dart';
import 'package:googlemap/pages/mapPage2.dart';
import 'package:googlemap/pages/orderTrackinPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyGoogle(),
    );
  }
}

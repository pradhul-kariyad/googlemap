// ignore_for_file: file_names
import 'package:google_places_flutter/model/place_details.dart';
import 'package:googlemap/pages/consts.dart'; // Your constants file
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<PlaceDetails> getPlaceDetailsFromPlaceId(String placeId) async {
  final url =
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAP_API_KEY";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return PlaceDetails.fromJson(json.decode(response.body)['result']);
  } else {
    throw Exception('Failed to load place details');
  }
}

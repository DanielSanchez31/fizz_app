import 'dart:convert';
import 'dart:async';
import 'package:fizz_app/src/api/environment.dart';
import 'package:fizz_app/src/models/directions.dart';
import 'package:http/http.dart' as http;

class GoogleProvider {
  Future<dynamic> getGoogleMapsDirections (double fromLat, double fromLng, double toLat, double toLng) async {

    Uri uri = Uri.https(
        'maps.googleapis.com',
        'maps/api/directions/json', {
          'key' : Environment.api_key_maps,
          'origin' : '$fromLat,$fromLng',
          'destination' : '$toLat,$toLng',
          'traffic_model' : 'best_guess',
          'departure_time' : DateTime.now().microsecondsSinceEpoch.toString(),
          'mode' : 'driving',
          'transit_routing_preferences' : 'less_driving'
        }
    );

    final response = await http.get(uri);
    final decodeData = json.decode(response.body);
    final leg = new Direction.fromJsonMap(decodeData['routes'][0]['legs'][0]);
    return leg;
  }
}
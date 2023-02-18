import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  String url = 'https://api.openrouteservice.org/v2/directions/';
  String apiKey = '5b3ce3597851110001cf624832eeea4421be4bcfab372e6c8fea50ca';
  String journeyMode = 'driving-car';
  double? startLng = 17.452639;

  double? startLat = 102.878590;
  double? endLng = 16.4053917;
  double? endLat = 102.807208;

  NetworkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLat,
    required this.endLng,
  });

  Future getData() async {
    Uri url2uri = Uri.parse(
        '$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');

    http.Response response = await http.get(url2uri);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

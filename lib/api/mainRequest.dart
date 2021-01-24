import 'dart:async';
import 'dart:convert';
import 'package:weatherApp/exception/exception.dart';
import 'package:weatherApp/models/weatherModel.dart';
import 'package:http/http.dart' as http;

class MainRequest {
  final api = "81ffe2b5491701fb9fa1a0cdf7043172";

  Future<GetWeatherData> sendCityName(String cityName) async {
    final url =
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api";

    try {
      final response = await http.get(url);

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("All Greens");
        print(jsonResponse);
        return GetWeatherData.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        print("status is 400,   bad request");
      } else if (response.statusCode == 500) {
        print("status is 500,   server error");
      } 
      else {
        print("we'll be safe, maybe, maybe not");
      }
      // print(jsonResponse);
      // return GetWeatherData.fromJson(jsonResponse);

    } on FetchCityException catch (e) {
      print("Error caught : $e");
    }
  }
}

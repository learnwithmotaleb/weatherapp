// weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/Weather_Model.dart';

class WeatherService {
  final String apiKey = '8765ab5c0e9f4d9bbff182616252501'; // Replace with your API key
  final String baseUrl = 'https://api.weatherapi.com/v1/forecast.json';

  Future<WeatherResponse> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?key=$apiKey&q=$city&days=7'));

    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
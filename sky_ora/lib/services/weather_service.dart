import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'b37f4386a9e2726838c55ac446b6c8e7'; // Apni OpenWeatherMap API key yahan dalein
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
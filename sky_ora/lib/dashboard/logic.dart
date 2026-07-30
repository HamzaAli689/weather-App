import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/AppSettingsService.dart';
import '../services/weather_service.dart';

class DashboardLogic extends GetxController {
  // Settings service ko find kar rahe hain taake unit ka pata chal sakay
  final AppSettingsService _settingsService = Get.find<AppSettingsService>();

  var cityName = "Loading...".obs;
  var temperature = "0°C".obs;
  var condition = "--".obs;
  var feelsLike = "Feels like 0°C".obs;
  var humidity = "0%".obs;
  var windSpeed = "0 km/h".obs;
  var pressure = "0 hPa".obs;
  var visibility = "0 km".obs;
  var isLoading = false.obs;

  var hourlyForecast = <Map<String, dynamic>>[].obs;

  // Raw values store rakhne ke liye taake unit change hone par dobara API call na karni pare
  double _rawTemp = 0.0;
  double _rawFeelsLike = 0.0;
  List<Map<String, dynamic>> _rawHourlyList = [];

  @override
  void onInit() {
    super.onInit();
    getWeatherData("Vehari"); // Default location

    // Listen to unit changes (Jab bhi user Settings se °C/°F change kare ga, UI foran update ho gi)
    ever(_settingsService.isCelsius, (_) {
      _updateFormattedValues();
    });
  }

  // Naye city ka data fetch karne ke liye method
  void changeCity(String newCity) {
    getWeatherData(newCity);
  }

  void getWeatherData(String city) async {
    try {
      isLoading.value = true;

      // 1. Current Weather
      var data = await WeatherService.fetchWeather(city);
      cityName.value = "${data['name']}, ${data['sys']['country']}";

      _rawTemp = (data['main']['temp'] as num).toDouble();
      _rawFeelsLike = (data['main']['feels_like'] as num).toDouble();

      condition.value = data['weather'][0]['main'];
      humidity.value = "${data['main']['humidity']}%";
      windSpeed.value = "${data['wind']['speed']} km/h";
      pressure.value = "${data['main']['pressure']} hPa";
      visibility.value = "${(data['visibility'] / 1000)} km";

      // 2. Hourly Forecast (12+ hours)
      var forecastData = await WeatherService.fetchForecast(city);
      if (forecastData != null && forecastData['list'] != null) {
        List items = forecastData['list'];

        _rawHourlyList = items.take(12).map<Map<String, dynamic>>((item) {
          String dateTimeStr = item['dt_txt'] ?? "";
          String formattedTime = dateTimeStr.isNotEmpty
              ? _formatTime(dateTimeStr)
              : "";

          return {
            'time': formattedTime,
            'temp': (item['main']['temp'] as num).toDouble(),
            'condition': item['weather'][0]['main'],
            'icon': _getWeatherIcon(item['weather'][0]['main']),
          };
        }).toList();
      }

      // Format values according to selected temperature unit (°C / °F)
      _updateFormattedValues();

    } catch (e) {
      Get.snackbar("Error", "Could not fetch weather data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Temperature aur Unit ko format karne ka logic
  void _updateFormattedValues() {
    String unitSymbol = _settingsService.isCelsius.value ? "°C" : "°F";

    // Main Temperature
    double convertedTemp = _settingsService.convertTemp(_rawTemp);
    temperature.value = "${convertedTemp.round()}$unitSymbol";

    // Feels Like
    double convertedFeelsLike = _settingsService.convertTemp(_rawFeelsLike);
    feelsLike.value = "Feels like ${convertedFeelsLike.round()}$unitSymbol";

    // Hourly Forecast Temperature Conversion
    if (_rawHourlyList.isNotEmpty) {
      hourlyForecast.value = _rawHourlyList.map((item) {
        double rawHourTemp = item['temp'];
        double convertedHourTemp = _settingsService.convertTemp(rawHourTemp);

        return {
          'time': item['time'],
          'temp': "${convertedHourTemp.round()}$unitSymbol",
          'condition': item['condition'],
          'icon': item['icon'],
        };
      }).toList();
    }
  }

  String _formatTime(String dtTxt) {
    try {
      DateTime parsedDate = DateTime.parse(dtTxt);
      int hour = parsedDate.hour;
      String period = hour >= 12 ? "PM" : "AM";
      int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$formattedHour:00 $period";
    } catch (e) {
      return dtTxt;
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}
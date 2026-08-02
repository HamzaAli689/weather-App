import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/AppSettingsService.dart';
import '../services/weather_service.dart';

class DashboardLogic extends GetxController {
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
  var dailyForecast = <Map<String, dynamic>>[].obs;

  // Raw values for unit conversion
  double _rawTemp = 0.0;
  double _rawFeelsLike = 0.0;
  List<Map<String, dynamic>> _rawHourlyList = [];
  List<Map<String, dynamic>> _rawDailyList = [];

  @override
  void onInit() {
    super.onInit();
    getWeatherData("Vehari");

    ever(_settingsService.isCelsius, (_) {
      _updateFormattedValues();
    });
  }

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

      // 2. Forecast Data (Hourly & Daily)
      var forecastData = await WeatherService.fetchForecast(city);
      if (forecastData != null && forecastData['list'] != null) {
        List items = forecastData['list'];

        // Hourly (12 items) - Fixed Type Casting
        _rawHourlyList = items.take(12).map<Map<String, dynamic>>((item) {
          String dateTimeStr = item['dt_txt'] ?? "";
          String formattedTime = dateTimeStr.isNotEmpty ? _formatTime(dateTimeStr) : "";

          return {
            'time': formattedTime,
            'temp': (item['main']['temp'] as num).toDouble(),
            'condition': item['weather'][0]['main'],
            'icon': _getWeatherIcon(item['weather'][0]['main']),
          };
        }).toList();

        // Daily / 7-Day Forecast filter
        Map<String, dynamic> dailyMap = {};
        for (var item in items) {
          String dtTxt = item['dt_txt'] ?? "";
          if (dtTxt.contains("12:00:00")) {
            String dayName = _formatDayName(dtTxt);
            dailyMap[dayName] = {
              'day': dayName,
              'date': dtTxt.split(' ')[0],
              'temp_min': (item['main']['temp_min'] as num).toDouble(),
              'temp_max': (item['main']['temp_max'] as num).toDouble(),
              'condition': item['weather'][0]['main'],
              'description': item['weather'][0]['description'] ?? 'Weather condition expected.',
              'icon': _getWeatherIcon(item['weather'][0]['main']),
            };
          }
        }
        // ✅ Explicitly cast to Map<String, dynamic> list to resolve type error
        _rawDailyList = dailyMap.values.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      _updateFormattedValues();
    } catch (e) {
      Get.snackbar("Error", "Could not fetch weather data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFormattedValues() {
    String unitSymbol = _settingsService.isCelsius.value ? "°C" : "°F";

    // Main Temp
    double convertedTemp = _settingsService.convertTemp(_rawTemp);
    temperature.value = "${convertedTemp.round()}$unitSymbol";

    double convertedFeelsLike = _settingsService.convertTemp(_rawFeelsLike);
    feelsLike.value = "Feels like ${convertedFeelsLike.round()}$unitSymbol";

    // Hourly Forecast
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

    // Daily Forecast
    if (_rawDailyList.isNotEmpty) {
      dailyForecast.value = _rawDailyList.map((item) {
        double convMax = _settingsService.convertTemp(item['temp_max']);
        double convMin = _settingsService.convertTemp(item['temp_min']);

        return {
          'day': item['day'],
          'date': item['date'],
          'tempHigh': "${convMax.round()}$unitSymbol",
          'tempLow': "${convMin.round()}$unitSymbol",
          'condition': item['condition'],
          'description': item['description'],
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

  String _formatDayName(String dtTxt) {
    try {
      DateTime parsedDate = DateTime.parse(dtTxt);
      List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
      return days[parsedDate.weekday - 1];
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
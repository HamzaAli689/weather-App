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

      // 2. Forecast Data (Hourly & Daily 7-10 days collection)
      var forecastData = await WeatherService.fetchForecast(city);
      if (forecastData != null && forecastData['list'] != null) {
        List items = forecastData['list'];

        // Expand API 3-hour data into 24 continuous hourly slots (0 to 23 hours)
        _rawHourlyList = _generate24HoursList(items);

        // Daily Forecast filter (Grouping by date to get up to 7-10 distinct future days)
        Map<String, dynamic> dailyMap = {};
        for (var item in items) {
          String dtTxt = item['dt_txt'] ?? "";
          if (dtTxt.isNotEmpty) {
            String dateKey = dtTxt.split(' ')[0]; // e.g., "2026-08-05"

            if (dtTxt.contains("12:00:00") || !dailyMap.containsKey(dateKey)) {
              String dayName = _formatDayName(dtTxt);
              String formattedDate = _formatDateStr(dtTxt);

              dailyMap[dateKey] = {
                'day': dayName,
                'date': dateKey,
                'formattedDate': formattedDate,
                'temp_max': (item['main']['temp'] as num).toDouble(),
                'condition': item['weather'][0]['main'],
                'description': item['weather'][0]['description'] ?? 'Weather condition expected.',
                'icon': _getWeatherIcon(item['weather'][0]['main']),
              };
            }
          }
        }

        _rawDailyList = dailyMap.values.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      _updateFormattedValues();
    } catch (e) {
      Get.snackbar("Error", "Could not fetch weather data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper to generate full 24 hours list from API items
  List<Map<String, dynamic>> _generate24HoursList(List apiItems) {
    List<Map<String, dynamic>> expandedList = [];

    Map<int, Map<String, dynamic>> apiHourMap = {};
    for (var item in apiItems) {
      try {
        DateTime dt = DateTime.parse(item['dt_txt']);
        if (dt.day == DateTime.now().day || apiHourMap.isEmpty) {
          apiHourMap[dt.hour] = item;
        }
      } catch (_) {}
    }

    double baseTemp = _rawTemp;
    String baseCond = condition.value;
    IconData baseIcon = _getWeatherIcon(baseCond);

    for (int hour = 0; hour < 24; hour++) {
      double temp = baseTemp;
      String cond = baseCond;
      IconData icon = baseIcon;

      if (apiHourMap.containsKey(hour)) {
        var matchedItem = apiHourMap[hour]!;
        temp = (matchedItem['main']['temp'] as num).toDouble();
        cond = matchedItem['weather'][0]['main'];
        icon = _getWeatherIcon(cond);
      } else {
        temp = baseTemp + ((hour % 3) * 0.5);
      }

      String period = hour >= 12 ? "PM" : "AM";
      int hour12 = hour % 12;
      if (hour12 == 0) hour12 = 12;
      String timeString = "$hour12:00 $period";

      expandedList.add({
        'hour': hour, // ✅ Stored raw hour for comparison
        'time': timeString,
        'temp': temp,
        'condition': cond,
        'icon': icon,
      });
    }

    return expandedList;
  }

  void _updateFormattedValues() {
    String unitSymbol = _settingsService.isCelsius.value ? "°C" : "°F";
    int currentHour = DateTime.now().hour; // ✅ Current system hour tracking

    // Main Temp
    double convertedTemp = _settingsService.convertTemp(_rawTemp);
    temperature.value = "${convertedTemp.round()}$unitSymbol";

    double convertedFeelsLike = _settingsService.convertTemp(_rawFeelsLike);
    feelsLike.value = "Feels like ${convertedFeelsLike.round()}$unitSymbol";

    // Hourly Forecast with Highlight Support matching Detail Screen
    if (_rawHourlyList.isNotEmpty) {
      hourlyForecast.value = _rawHourlyList.map((item) {
        double rawHourTemp = item['temp'];
        double convertedHourTemp = _settingsService.convertTemp(rawHourTemp);
        bool isCurrentHour = (item['hour'] == currentHour);

        return {
          'time': item['time'],
          'temp': "${convertedHourTemp.round()}$unitSymbol",
          'condition': item['condition'],
          'icon': item['icon'],
          'isCurrentHour': isCurrentHour, // ✅ Flag passed to UI for styling matching detail screen
        };
      }).toList();
    }

    // Daily Forecast
    if (_rawDailyList.isNotEmpty) {
      dailyForecast.value = _rawDailyList.map((item) {
        double convTemp = _settingsService.convertTemp(item['temp_max']);

        return {
          'day': item['day'],
          'date': item['date'],
          'formattedDate': item['formattedDate'],
          'tempHigh': "${convTemp.round()}$unitSymbol",
          'condition': item['condition'],
          'description': item['description'],
          'icon': item['icon'],
        };
      }).toList();
    }
  }

  String _formatDayName(String dtTxt) {
    try {
      DateTime parsedDate = DateTime.parse(dtTxt);
      DateTime now = DateTime.now();

      if (parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day) {
        return "Today";
      }

      List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
      return days[parsedDate.weekday - 1];
    } catch (e) {
      return dtTxt;
    }
  }

  String _formatDateStr(String dtTxt) {
    try {
      DateTime parsedDate = DateTime.parse(dtTxt);
      List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      return "${months[parsedDate.month - 1]} ${parsedDate.day}";
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
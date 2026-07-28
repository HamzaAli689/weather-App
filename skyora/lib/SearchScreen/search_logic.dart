import 'package:get/get.dart';

class SearchViewController extends GetxController {
  var searchQuery = "".obs;

  // Recent searches list (aap isme live API data bhi map kar sakte hain)
  var recentSearches = <Map<String, dynamic>>[
    {"city": "Lahore", "country": "Pakistan", "temp": "32°C", "condition": "Sunny"},
    {"city": "Dubai", "country": "UAE", "temp": "36°C", "condition": "Hazy"},
    {"city": "London", "country": "UK", "temp": "18°C", "condition": "Rainy"},
    {"city": "New York", "country": "US", "temp": "24°C", "condition": "Partly Cloudy"},
  ].obs;

  void searchCity(String cityName) {
    if (cityName.isNotEmpty) {
      // Yahan aap OpenWeather API call karke naya data fetch kar sakte hain
      print("Searching weather for: $cityName");
      Get.back(); // Search ke baad wapis dashboard par jane ke liye
    }
  }

  void clearHistory() {
    recentSearches.clear();
  }
}
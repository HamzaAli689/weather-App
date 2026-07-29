import 'package:get/get.dart';
import '../dashboard/logic.dart';

class SearchViewController extends GetxController {
  // Recent searches list ko reactive (.obs) banaya hai
  var recentSearches = <Map<String, dynamic>>[
    {"city": "Lahore", "country": "Pakistan", "temp": "32°C", "condition": "Sunny"},
    {"city": "Dubai", "country": "UAE", "temp": "36°C", "condition": "Hazy"},
    {"city": "London", "country": "UK", "temp": "18°C", "condition": "Rainy"},
    {"city": "New York", "country": "US", "temp": "24°C", "condition": "Partly Cloudy"},
  ].obs;

  // Jab user search bar me type karke enter kare
  void searchCity(String cityName) {
    if (cityName.trim().isNotEmpty) {
      String formattedCity = cityName.trim();

      // Check karein ke city pehle se list mein hai ya nahi, agar hai toh remove kar dein taake duplicate na ho aur top par aa jaye
      recentSearches.removeWhere((item) => item["city"].toString().toLowerCase() == formattedCity.toLowerCase());

      // Nayi search ko list ke top (index 0) par add kar dein
      recentSearches.insert(0, {
        "city": formattedCity,
        "country": "International", // Aap API se country bhi fetch kar sakte hain
        "temp": "--°C",
        "condition": "Unknown",
      });

      // Dashboard ka weather update karne ke liye
      selectCity(formattedCity);
    }
  }

  // Jab user kisi bhi recent search par click kare
  void selectCity(String cityName) {
    if (cityName.isNotEmpty) {
      if (Get.isRegistered<DashboardLogic>()) {
        final dashboardLogic = Get.find<DashboardLogic>();
        dashboardLogic.getWeatherData(cityName);
      }
      Get.back(); // Wapis Dashboard par jane ke liye
    }
  }

  // History clear karne ke liye
  void clearHistory() {
    recentSearches.clear();
  }
}
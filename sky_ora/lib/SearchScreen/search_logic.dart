// import 'package:get/get.dart';
// import '../services/weather_service.dart';
//
// class SearchLogic extends GetxController {
//   var recentSearches = <String>[].obs;
//   var isLoading = false.obs;
//
//   void searchAndReturnCity(String cityName) async {
//     if (cityName.trim().isEmpty) return;
//
//     try {
//       isLoading.value = true;
//       // API se check kar rahe hain ke city theek hai ya nahi
//       var data = await WeatherService.fetchWeather(cityName);
//
//       String formalCityName = "${data['name']}, ${data['sys']['country']}";
//
//       // History mein add karna
//       if (!recentSearches.contains(formalCityName)) {
//         recentSearches.insert(0, formalCityName);
//       }
//
//       // ✅ Sab se important step: Dashboard par city name return karna
//       Get.back(result: formalCityName);
//
//     } catch (e) {
//       Get.snackbar("Error", "City not found. Please check the name.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void removeSearchItem(String city) {
//     recentSearches.remove(city);
//   }
// }
import 'package:get/get.dart';
import '../services/weather_service.dart';

class SearchLogic extends GetxController {
  // ✅ Ye list ab destroy nahi hogi agar controller permanent ho
  var recentSearches = <String>[].obs;
  var isLoading = false.obs;

  void searchAndReturnCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    try {
      isLoading.value = true;
      var data = await WeatherService.fetchWeather(cityName);

      String formalCityName = "${data['name']}, ${data['sys']['country']}";

      // Agar list mein pehle se nahi hai toh top par add kar dein
      if (!recentSearches.contains(formalCityName)) {
        recentSearches.insert(0, formalCityName);
      }

      // Wapas dashboard par bhej dein
      Get.back(result: formalCityName);

    } catch (e) {
      Get.snackbar("Error", "City not found. Please check the name.");
    } finally {
      isLoading.value = false;
    }
  }

  void removeSearchItem(String city) {
    recentSearches.remove(city);
  }
}
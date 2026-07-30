import 'package:get/get.dart';
import '../services/AppSettingsService.dart';

class SettingsLogic extends GetxController {
  final AppSettingsService settingsService = Get.find<AppSettingsService>();

  // Getters jo UI mein use honge
  bool get isDarkMode => settingsService.isDarkMode.value;
  bool get isCelsius => settingsService.isCelsius.value;
  bool get weatherAlerts => settingsService.weatherAlerts.value;

  void toggleDarkMode(bool value) {
    settingsService.toggleDarkMode(value);
    update();
  }

  void toggleTemperatureUnit(bool celsius) {
    settingsService.toggleTemperatureUnit(celsius);
    update();
  }

  void toggleWeatherAlerts(bool value) {
    settingsService.toggleWeatherAlerts(value);
    update();
  }
}
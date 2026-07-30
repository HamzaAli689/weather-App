import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsService extends GetxService {
  final box = GetStorage();

  var isDarkMode = true.obs;
  var isCelsius = true.obs; // true = °C, false = °F
  var weatherAlerts = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Saved settings load kar rahe hain
    isDarkMode.value = box.read('isDarkMode') ?? true;
    isCelsius.value = box.read('isCelsius') ?? true;
    weatherAlerts.value = box.read('weatherAlerts') ?? true;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    box.write('isDarkMode', value);
    // Yahan agar app ki theme change karni ho:
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTemperatureUnit(bool celsius) {
    isCelsius.value = celsius;
    box.write('isCelsius', celsius);
  }

  void toggleWeatherAlerts(bool value) {
    weatherAlerts.value = value;
    box.write('weatherAlerts', value);
  }

  // Temperature convert karne ka formula (°C to °F)
  double convertTemp(double celsiusTemp) {
    if (isCelsius.value) {
      return celsiusTemp;
    } else {
      return (celsiusTemp * 9 / 5) + 32; // Fahrenheit formula
    }
  }
}
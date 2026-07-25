import 'package:get/get.dart';

import '../services/weather_service.dart';

class DashboardLogic extends GetxController {
  var cityName = "San Francisco, US".obs;
  var temperature = "32°C".obs;
  var condition = "Sunny".obs;
  var feelsLike = "Feels like 34°C".obs;
  var humidity = "75%".obs;
  var windSpeed = "15 km/h".obs;
  var pressure = "1015 hPa".obs;
  var visibility = "10 km".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWeatherData(cityName.value);
  }

  void getWeatherData(String city) async {
    try {
      isLoading.value = true;
      var data = await WeatherService.fetchWeather(city);

      cityName.value = "${data['name']}, ${data['sys']['country']}";
      temperature.value = "${data['main']['temp'].round()}°C";
      condition.value = data['weather'][0]['main'];
      feelsLike.value = "Feels like ${data['main']['feels_like'].round()}°C";
      humidity.value = "${data['main']['humidity']}%";
      windSpeed.value = "${data['wind']['speed']} km/h";
      pressure.value = "${data['main']['pressure']} hPa";
      visibility.value = "${(data['visibility'] / 1000)} km";
    } catch (e) {
      Get.snackbar("Error", "Could not fetch weather data");
    } finally {
      isLoading.value = false;
    }
  }

}

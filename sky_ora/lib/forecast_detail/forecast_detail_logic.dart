import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForecastDetailLogic extends GetxController {
  var selectedDayName = "".obs;
  var selectedDateStr = "".obs;
  var selectedCondition = "".obs;
  var selectedDescription = "".obs;
  var selectedTemp = "".obs;
  var selectedIcon = Icons.wb_sunny.obs;

  // Extra metrics
  var uvIndex = "4 Moderate".obs;
  var rainChance = "10%".obs;
  var windSpeed = "12 km/h".obs;
  var humidity = "45%".obs;

  // 24-Hour hourly forecast list
  var hourly24Forecast = <Map<String, dynamic>>[].obs;

  // ✅ Track current active hour index for highlighting if "Today"
  var currentActiveHourIndex = (-1).obs;
  var isTodaySelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      var data = Get.arguments;
      selectedDayName.value = data['day'] ?? 'Selected Day';
      selectedDateStr.value = data['formattedDate'] ?? data['date'] ?? '';
      selectedCondition.value = data['condition'] ?? 'Clear';
      selectedDescription.value = data['description'] ?? 'Weather condition expected.';
      selectedTemp.value = data['tempHigh'] ?? '38°C';
      selectedIcon.value = data['icon'] ?? Icons.wb_sunny;

      isTodaySelected.value = (selectedDayName.value.toLowerCase() == 'today');
      _generate24HourData(selectedCondition.value);
    }
  }

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              surface: Color(0xFF0F172A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0F172A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDayName.value = _formatDayName(picked);
      selectedDateStr.value = _formatDateStr(picked);
      isTodaySelected.value = _isToday(picked);
      _updateWeatherForSelectedDate(picked);
    }
  }

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  void _updateWeatherForSelectedDate(DateTime date) {
    int dayNum = date.day;
    if (dayNum % 3 == 0) {
      selectedCondition.value = "Rainy Showers";
      selectedDescription.value = "Expect scattered thunderstorms and rain drops throughout the day.";
      selectedTemp.value = "${30 + (dayNum % 5)}°C";
      selectedIcon.value = Icons.umbrella;
      rainChance.value = "85%";
      humidity.value = "78%";
    } else if (dayNum % 2 == 0) {
      selectedCondition.value = "Cloudy Sky";
      selectedDescription.value = "Overcast skies with cool breeze and minimal sunlight.";
      selectedTemp.value = "${33 + (dayNum % 4)}°C";
      selectedIcon.value = Icons.cloud;
      rainChance.value = "25%";
      humidity.value = "55%";
    } else {
      selectedCondition.value = "Sunny & Clear";
      selectedDescription.value = "Bright sunny weather conditions expected with clear skies.";
      selectedTemp.value = "${37 + (dayNum % 4)}°C";
      selectedIcon.value = Icons.wb_sunny;
      rainChance.value = "5%";
      humidity.value = "35%";
    }

    _generate24HourData(selectedCondition.value);
  }

  void _generate24HourData(String condition) {
    List<Map<String, dynamic>> generatedList = [];
    int currentHour = DateTime.now().hour;

    for (int hour = 0; hour < 24; hour++) {
      String timeLabel = _format24Hour(hour);
      IconData icon = Icons.wb_sunny;
      String tempStr = "35°C";

      if (hour < 6 || hour > 20) {
        icon = Icons.nightlight_round;
        tempStr = "28°C";
      } else if (condition.contains("Rain")) {
        icon = Icons.umbrella;
        tempStr = "31°C";
      } else if (condition.contains("Cloud")) {
        icon = Icons.cloud;
        tempStr = "33°C";
      } else {
        icon = hour >= 18 ? Icons.nights_stay : Icons.wb_sunny;
        tempStr = "${34 + (hour % 3)}°C";
      }

      generatedList.add({
        'hour': hour,
        'time': timeLabel,
        'temp': tempStr,
        'icon': icon,
      });
    }
    hourly24Forecast.value = generatedList;

    // ✅ Match current hour if Today is selected
    if (isTodaySelected.value) {
      currentActiveHourIndex.value = currentHour;
    } else {
      currentActiveHourIndex.value = -1; // No highlight for other days
    }
  }

  String _format24Hour(int hour) {
    // 24-hour format logic showing hours (00:00 to 23:00)
    String h = hour.toString().padLeft(2, '0');
    return "$h:00";
  }

  String _formatDayName(DateTime date) {
    if (_isToday(date)) {
      return "Today";
    }
    List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return days[date.weekday - 1];
  }

  String _formatDateStr(DateTime date) {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
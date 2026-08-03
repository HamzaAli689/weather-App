import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../SearchScreen/search_view.dart';
import '../forecast_detail/forecast_detail_view.dart';
import '../setting/view.dart';
import 'logic.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardLogic controller = Get.put(DashboardLogic());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Deep Navy Top
              Color(0xFF1E3A8A), // Rich Blue
              Color(0xFF090D16), // Dark Bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(
                () => controller.isLoading.value
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Location & Icons Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String? selectedCity = await Get.to(() => const SearchScreen());

                          if (selectedCity != null && selectedCity.isNotEmpty) {
                            controller.changeCity(selectedCity);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              controller.cityName.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String? selectedCity = await Get.to(() => const SearchScreen());

                              if (selectedCity != null && selectedCity.isNotEmpty) {
                                controller.changeCity(selectedCity);
                              }
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => SettingPage());
                            },
                            child: const Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Main Glass Weather Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.wb_sunny,
                          color: Color(0xFFFBBF24),
                          size: 64,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.temperature.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.condition.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.feelsLike.value,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Weather Metrics Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _buildStatCard(
                        "Humidity",
                        controller.humidity.value,
                        Icons.water_drop_outlined,
                      ),
                      _buildStatCard(
                        "Wind Speed",
                        controller.windSpeed.value,
                        Icons.air,
                      ),
                      _buildStatCard(
                        "Pressure",
                        controller.pressure.value,
                        Icons.speed,
                      ),
                      _buildStatCard(
                        "Visibility",
                        controller.visibility.value,
                        Icons.visibility_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Hourly Forecast Section Title
                  const Text(
                    "Today's Forecast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Hourly Forecast Horizontal Scroll (24 Hours with Current Time Highlighted)
                  SizedBox(
                    height: 110,
                    child: controller.hourlyForecast.isEmpty
                        ? const Center(
                      child: Text(
                        "No forecast data available",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.hourlyForecast.length,
                      itemBuilder: (context, index) {
                        final hourly = controller.hourlyForecast[index];
                        bool isCurrentHour = hourly['isCurrentHour'] ?? false;

                        return _buildHourlyCard(
                          hourly['time'],
                          hourly['temp'],
                          hourly['icon'],
                          isCurrentHour,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 7-10 Days Forecast Section Title
                  const Text(
                    "7-Day Extended Forecast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 7-10 Days Separate Glass Cards List
                  controller.dailyForecast.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "Loading Extended Forecast...",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: controller.dailyForecast.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final dayData = controller.dailyForecast[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ForecastDetailView(), arguments: dayData);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dayData['day'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        dayData['formattedDate'],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(dayData['icon'], color: const Color(0xFFFBBF24), size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      dayData['condition'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  dayData['tempHigh'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.lightBlueAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyCard(
      String time,
      String temp,
      IconData icon,
      bool isCurrentHour,
      ) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        // ✅ Same amber highlight colors matching detail screen
        color: isCurrentHour ? Colors.amber.withOpacity(0.18) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentHour ? Colors.amber : Colors.white.withOpacity(0.08),
          width: isCurrentHour ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            time,
            style: TextStyle(
              color: isCurrentHour ? Colors.amberAccent : Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Icon(
            icon,
            color: isCurrentHour ? Colors.amber : const Color(0xFFFBBF24),
            size: 22,
          ),
          Text(
            temp,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
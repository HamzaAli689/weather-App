import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../SearchScreen/search_view.dart';
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
                              onTap: () {
                                // Yahan search screen par navigate kar rahe hain
                                //Get.toNamed('/search');
                                // Agar named routes use nahi kar rahe toh ye use karein:
                                Get.to(() => const SearchScreen());
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
                                  onTap: () {
                                    // Yahan search screen par navigate kar rahe hain
                                    //Get.toNamed('/search');
                                    // Agar named routes use nahi kar rahe toh ye use karein:
                                    Get.to(() => const SearchScreen());
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.white70,
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

                        // Section Title
                        const Text(
                          "Today's Forecast",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Hourly Forecast Horizontal Scroll
                        SizedBox(
                          height: 105,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildHourlyCard(
                                "10:00",
                                "32°C",
                                Icons.wb_sunny,
                                true,
                              ),
                              _buildHourlyCard(
                                "11:00",
                                "33°C",
                                Icons.wb_sunny,
                                false,
                              ),
                              _buildHourlyCard(
                                "12:00",
                                "34°C",
                                Icons.wb_sunny,
                                false,
                              ),
                              _buildHourlyCard(
                                "13:00",
                                "33°C",
                                Icons.cloud,
                                false,
                              ),
                            ],
                          ),
                        ),
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
    bool isSelected,
  ) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1E3A8A).withOpacity(0.8)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF60A5FA).withOpacity(0.5)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Icon(icon, color: const Color(0xFFFBBF24), size: 22),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

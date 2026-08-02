import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForecastDetailView extends StatelessWidget {
  final Map<String, dynamic> weatherData; // Isme clicked day ka data aaye ga

  const ForecastDetailView({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data extract karna jo pichli screen se pass hua hai
    final String dayName = weatherData['day'] ?? 'Tuesday, August 4';
    final String condition = weatherData['condition'] ?? 'Scattered Thunderstorms';
    final String tempHigh = weatherData['tempHigh'] ?? '38°';
    final String tempLow = weatherData['tempLow'] ?? '26°';
    final String description = weatherData['description'] ?? 'Thunderstorms expected in the afternoon. Feels like 40°C.';
    final IconData weatherIcon = weatherData['icon'] ?? Icons.wb_sunny_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF090D16),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    Text(
                      dayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month, color: Colors.white54),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                const Gap(20),

                // Hero Glassmorphism Weather Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(weatherIcon, color: Colors.amber, size: 70),
                      const Gap(15),
                      Text(
                        "High: $tempHigh / Low: $tempLow",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        condition,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(25),

                // Hourly Breakdown for That Day (Horizontal Scroll)
                const Text(
                  "Hourly Breakdown",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Gap(12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 75,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: index == 2 ? const Color(0xFF3B82F6).withOpacity(0.3) : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: index == 2 ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(index + 9)} AM",
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const Icon(Icons.wb_sunny, color: Colors.amber, size: 22),
                            Text(
                              "${34 + index}°",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Gap(25),

                // 2x2 Grid Metrics (UV, Rain, Wind, Humidity)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMetricCard("UV Index", "7 High", Icons.wb_sunny_outlined),
                    _buildMetricCard("Chance of Rain", "65%", Icons.water_drop_outlined),
                    _buildMetricCard("Average Wind", "15 km/h", Icons.air),
                    _buildMetricCard("Humidity", "82%", Icons.opacity),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Metric Card Widget Helper
  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(icon, color: Colors.lightBlueAccent, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
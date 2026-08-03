import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'forecast_detail_logic.dart';

class ForecastDetailView extends StatelessWidget {
  const ForecastDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForecastDetailLogic controller = Get.put(ForecastDetailLogic());

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
            child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
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
                      Column(
                        children: [
                          Text(
                            controller.selectedDayName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.selectedDateStr.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => controller.pickDate(context),
                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.08),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        tooltip: "Select Any Date",
                      ),
                    ],
                  ),
                  const Gap(25),

                  // Hero Weather Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Icon(controller.selectedIcon.value, color: const Color(0xFFFBBF24), size: 70),
                        const Gap(15),
                        Text(
                          controller.selectedTemp.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          controller.selectedCondition.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          controller.selectedDescription.value,
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

                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "24-Hour Hourly Forecast",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.isTodaySelected.value)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: const Text(
                            "Current Time Highlighted",
                            style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const Gap(15),

                  // ✅ 24-Hour Hourly Forecast Horizontal List with Highlighting
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.hourly24Forecast.length,
                      itemBuilder: (context, index) {
                        final hourlyItem = controller.hourly24Forecast[index];
                        bool isCurrentHour = (hourlyItem['hour'] == controller.currentActiveHourIndex.value);

                        return Container(
                          width: 75,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            // Highlight background if it's current hour
                            color: isCurrentHour ? Colors.amber.withOpacity(0.18) : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              // Highlight border if it's current hour
                              color: isCurrentHour ? Colors.amber : Colors.white.withOpacity(0.08),
                              width: isCurrentHour ? 2.0 : 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                hourlyItem['time'], // 24-hour format label e.g., "23:00"
                                style: TextStyle(
                                  color: isCurrentHour ? Colors.amberAccent : Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              Icon(
                                hourlyItem['icon'],
                                color: isCurrentHour ? Colors.amber : const Color(0xFFFBBF24),
                                size: 22,
                              ),
                              Text(
                                hourlyItem['temp'],
                                style: TextStyle(
                                  color: isCurrentHour ? Colors.white : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(25),

                  // Metrics Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMetricCard("UV Index", controller.uvIndex.value, Icons.wb_sunny_outlined),
                      _buildMetricCard("Chance of Rain", controller.rainChance.value, Icons.water_drop_outlined),
                      _buildMetricCard("Average Wind", controller.windSpeed.value, Icons.air),
                      _buildMetricCard("Humidity", controller.humidity.value, Icons.opacity),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(icon, color: Colors.lightBlueAccent, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}
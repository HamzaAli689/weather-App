import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsLogic controller = Get.put(SettingsLogic());

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar / Top Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Appearance Section
                const Text(
                  "Appearance",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Obx(() => _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(
                    // Yahan se .value hata diya hai taake error na aaye
                    value: controller.isDarkMode,
                    onChanged: controller.toggleDarkMode,
                    activeColor: Colors.blueAccent,
                  ),
                )),
                const SizedBox(height: 20),

                // Temperature Section
                const Text(
                  "Temperature",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                _buildSettingTile(
                  icon: Icons.thermostat,
                  title: "Temperature Unit",
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => controller.toggleTemperatureUnit(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              // Yahan se bhi .value hata diya hai
                              color: controller.isCelsius
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text("°C",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleTemperatureUnit(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              // Yahan se bhi .value hata diya hai
                              color: !controller.isCelsius
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text("°F",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                const SizedBox(height: 20),

                // Notifications Section
                const Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Obx(() => _buildSettingTile(
                  icon: Icons.notifications_active_outlined,
                  title: "Weather Alerts",
                  trailing: Switch(
                    // Yahan se bhi .value hata diya hai
                    value: controller.weatherAlerts,
                    onChanged: controller.toggleWeatherAlerts,
                    activeColor: Colors.blueAccent,
                  ),
                )),
                const SizedBox(height: 20),

                // About Section
                const Text(
                  "About",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: "App Version",
                  trailing: const Text(
                    "v1.2.6 (Build 45)",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.code,
                  title: "Developer",
                  trailing: const Text(
                    "Hamza Ali",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),

                const Spacer(),
                const Center(
                  child: Text(
                    "Weather App © 2026",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Glass Tile Widget
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.lightBlueAccent, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
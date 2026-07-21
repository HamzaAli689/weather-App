import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'logic.dart';

class SplashScreen extends GetView<SplashScreenLogic> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashScreenLogic controller = Get.put(SplashScreenLogic());

    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Video Container with Glassmorphism effect
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Center(
                    child: Obx(() {
                      if (controller.isVideoInitialized.value) {
                        return SizedBox(
                          width: 150,
                          height: 150,
                          child: VideoPlayer(controller.videoController),
                        );
                      } else {
                        return const CircularProgressIndicator(
                          color: Colors.white54,
                          strokeWidth: 2,
                        );
                      }
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              // App Title
              const Text(
                "SKYORA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                "Your Daily Forecast",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // Loading Indicator
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
              const SizedBox(height: 15),
              // App Version
              Text(
                "v1.2.6",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
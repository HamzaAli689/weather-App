import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SplashScreen extends GetView<SplashScreenLogic> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized
    Get.put(SplashScreenLogic());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Rich Deep Navy Top
              Color(0xFF1E3A8A), // Mid Blue Tone
              Color(0xFF090D16), // Dark Bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Glassmorphism Weather Icon Container
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
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
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glowing Blue Sun Element
                      Positioned(
                        top: 25,
                        left: 35,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00B4DB),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B4DB).withOpacity(0.6),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Fluffy White Cloud Element
                      Positioned(
                        bottom: 40,
                        child: Icon(
                          Icons.cloud,
                          size: 90,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ],
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
                  fontWeight: FontWeight.w400,
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_ora/splash_screen/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Skyora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'SF Pro Display',
      ),
      home: const SplashScreen(),
    );
  }
}
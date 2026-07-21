import 'package:get/get.dart';

class SplashScreenLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // 3 seconds delay for splash effect
    await Future.delayed(const Duration(seconds: 3));

    // Using GetX for smooth navigation to Home Screen (replace '/home' with your route)
    // Get.offAllNamed('/home');
  }

}

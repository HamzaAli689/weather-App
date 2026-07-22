import 'package:get/get.dart';
import 'package:skyora/onboarding/view.dart';

class SplashScreenLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // 3 seconds delay for splash effect
    await Future.delayed(const Duration(seconds: 3));

     Get.offAll(OnboardingPage()); // Home screen route
  }
}

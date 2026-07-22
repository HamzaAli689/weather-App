import 'package:get/get.dart';

class OnboardingLogic extends GetxController {
  var selectedPageIndex = 0.obs;

  void onPageChanged(int index) {
    selectedPageIndex.value = index;
  }

  void getStarted() {
    // Navigate to Home screen using GetX
    // Get.offAllNamed('/home');
  }
}

import 'package:get/get.dart';

import '../dashboard/view.dart';


class OnboardingLogic extends GetxController {
  var selectedPageIndex = 0.obs;

  void onPageChanged(int index) {
    selectedPageIndex.value = index;
  }

  void getStarted() {
    // Navigate to Home screen using GetX
    Get.offAll(DashboardPage());
  }
}

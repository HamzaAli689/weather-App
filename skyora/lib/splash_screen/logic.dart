import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashScreenLogic extends GetxController {
  late VideoPlayerController videoController;
  var isVideoInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initVideoPlayer();
    _navigateToHome();
  }

  void _initVideoPlayer() {
    // Apni video file ka path yahan specify karein
    videoController = VideoPlayerController.asset('Assets/video/2.mp4')
      ..initialize().then((_) {
        isVideoInitialized.value = true;
        videoController.play();
        videoController.setLooping(true); // Video loop me chalegi
      });
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4)); // 4 seconds delay
    videoController.dispose();
    // Get.offAllNamed('/home'); // Home screen route
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}

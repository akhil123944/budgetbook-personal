import 'package:get/get.dart';
import 'package:money_management/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // Delay for 3 seconds
    Get.offNamed(Routes.HOME); // Navigate to Home screen
  }
}

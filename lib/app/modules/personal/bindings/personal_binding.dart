import 'package:get/get.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';
import '../controllers/personal_controller.dart';

class PersonalBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Ensure PersonalController is always available
    if (!Get.isRegistered<PersonalController>()) {
      Get.put<PersonalController>(PersonalController(), permanent: true);
    }

    // ✅ Ensure HomeController is always available
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController(), permanent: true);
    }
  }
}
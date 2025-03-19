import 'package:get/get.dart';
import 'package:money_management/app/modules/personal/controllers/personal_controller.dart';
import 'package:money_management/app/modules/personal_edit/controllers/personal_edit_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Ensure PersonalController remains in memory when needed
    if (!Get.isRegistered<PersonalController>()) {
      Get.put<PersonalController>(PersonalController(), permanent: true);
    }

    // ✅ Ensure PersonalEditController is registered when needed
    Get.lazyPut<PersonalEditController>(() => PersonalEditController());

    // ✅ Ensure HomeController is registered and does not get deleted
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController(), permanent: true);
    }
  }
}
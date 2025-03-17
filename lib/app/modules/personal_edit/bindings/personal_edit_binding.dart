import 'package:get/get.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';
import '../controllers/personal_edit_controller.dart';

class PersonalEditBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController()); // ✅ Ensure HomeController is registered
    }
    Get.lazyPut<PersonalEditController>(() => PersonalEditController());
  }
}

import 'package:get/get.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';
import 'package:money_management/app/modules/personal_edit/controllers/personal_edit_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PersonalEditController>(
        () => PersonalEditController()); // ✅ Registered here
  }
}

import 'package:get/get.dart';
import '../controllers/personal_edit_controller.dart';

class PersonalEditBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Ensure PersonalEditController is registered only once
    if (!Get.isRegistered<PersonalEditController>()) {
      Get.lazyPut<PersonalEditController>(() => PersonalEditController());
    }
  }
}

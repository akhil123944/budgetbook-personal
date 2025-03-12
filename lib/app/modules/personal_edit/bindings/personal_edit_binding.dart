import 'package:get/get.dart';

import '../controllers/personal_edit_controller.dart';

class PersonalEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalEditController>(
      () => PersonalEditController(),
    );
  }
}

import 'package:get/get.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';

import '../controllers/personal_controller.dart';

class PersonalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalController>(
      () => PersonalController(),
    );
    Get.find<HomeController>();
  }
}

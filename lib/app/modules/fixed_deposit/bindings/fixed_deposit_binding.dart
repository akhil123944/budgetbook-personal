import 'package:get/get.dart';

import '../controllers/fixed_deposit_controller.dart';

class FixedDepositBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FixedDepositController>(
      () => FixedDepositController(),
    );
  }
}

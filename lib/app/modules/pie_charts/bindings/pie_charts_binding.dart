import 'package:get/get.dart';

import '../controllers/pie_charts_controller.dart';

class PieChartsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PieChartsController>(
      () => PieChartsController(),
    );
  }
}

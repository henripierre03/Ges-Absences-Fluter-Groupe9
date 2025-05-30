import 'package:get/get.dart';

import '../controllers/vigile_controller.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VigileController>(
      () => VigileController(),
    );
  }
}

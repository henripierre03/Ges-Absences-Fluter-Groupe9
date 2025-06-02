import 'package:frontend_gesabsence/app/data/services/springImpl/etudiant_api_service.dart';
import 'package:get/get.dart';

import '../controllers/vigile_controller.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EtudiantApiServiceSpring());
    
    Get.lazyPut<VigileController>(
      () => VigileController(
        etudiantApiService: Get.find<EtudiantApiServiceSpring>(),
      ),
    );
  }
}
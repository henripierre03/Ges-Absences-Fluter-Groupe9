import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:get/get.dart';

import '../controllers/vigile_controller.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EtudiantApiServiceImplJson());
    
    Get.lazyPut<VigileController>(
      () => VigileController(
        etudiantApiService: Get.find<EtudiantApiServiceImplJson>(),
      ),
    );
  }
}
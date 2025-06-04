import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/absence_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';

import '../controllers/vigile_controller.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    // Service pour les absences
    Get.lazyPut<IAbsenceService>(() => AbsenceApiServiceSpring());
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceSpring());

    // Contrôleur principal du vigile
    Get.lazyPut<VigileController>(
      () => VigileController(etudiantApiService: Get.find()),
    );
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

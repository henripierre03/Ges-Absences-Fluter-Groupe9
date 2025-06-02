import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/absence_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_liste_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<EtudiantController>(() => EtudiantController());

    // Services - Register both interface and concrete implementations
    Get.lazyPut<EtudiantApiServiceSpring>(() => EtudiantApiServiceSpring());
    Get.lazyPut<IEtudiantApiService>(
      () => Get.find<EtudiantApiServiceSpring>(),
    );

    Get.lazyPut<AbsenceApiServiceSpring>(() => AbsenceApiServiceSpring());
    Get.lazyPut<IAbsenceService>(() => Get.find<AbsenceApiServiceSpring>());

    Get.lazyPut<JustificationApiServiceImplJson>(
      () => JustificationApiServiceImplJson(),
    );

    // Controllers that depend on services
    Get.lazyPut<VigileController>(
      () =>
          VigileController(etudiantApiService: Get.find<IEtudiantApiService>()),
    );

    Get.lazyPut<VigileListController>(
      () => VigileListController(absenceService: Get.find<IAbsenceService>()),
    );
  }
}

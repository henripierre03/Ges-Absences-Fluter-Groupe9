import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => EtudiantApiServiceImplJson());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<EtudiantController>(() => EtudiantController());
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceSpring());
    Get.lazyPut<JustificationApiServiceImplJson>(
      () => JustificationApiServiceImplJson(),
    );
    // Injecte ici les autres controllers/services dont MainView a besoin
    // Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    // Get.lazyPut<EtudiantController>(() => EtudiantController());
    Get.lazyPut<EtudiantApiServiceSpring>(() => EtudiantApiServiceSpring());
    Get.lazyPut<VigileController>(
      () => VigileController(
        etudiantApiService: Get.find<EtudiantApiServiceSpring>(),
      ),
    );
  }
}

import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EtudiantApiServiceImplJson());
    Get.lazyPut<MainController>(() => MainController());

    // Injecte ici les autres controllers/services dont MainView a besoin
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    Get.lazyPut<EtudiantController>(() => EtudiantController());
    Get.lazyPut<VigileController>(
      () => VigileController(
        etudiantApiService: Get.find<EtudiantApiServiceImplJson>(),
      ),
    );
  }
}

import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:get/get.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    // Register the services
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    Get.lazyPut<JustificationApiServiceImplJson>(() => JustificationApiServiceImplJson());
    Get.lazyPut<EtudiantApiServiceImplJson>(() => EtudiantApiServiceImplJson());

    // Register the controller
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}

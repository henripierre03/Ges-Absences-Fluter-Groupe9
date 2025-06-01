import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:get/get.dart';
import '../controllers/vigile_controller.dart';

class VigileBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => EtudiantApiServiceImplJson());
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    Get.lazyPut<JustificationApiServiceImplJson>(
      () => JustificationApiServiceImplJson(),
    );

    // Controller - utiliser put au lieu de lazyPut pour s'assurer qu'il est disponible
    // dans toute l'application pour l'historique
    Get.put<VigileController>(
      VigileController(
        etudiantApiService: Get.find<EtudiantApiServiceImplJson>(),
      ),
      permanent: true, // Garde le controller en vie même si la page est fermée
    );
  }
}

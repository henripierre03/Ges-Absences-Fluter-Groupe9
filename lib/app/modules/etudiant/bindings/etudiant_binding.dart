import 'package:frontend_gesabsence/app/data/providers/etudiant_provider.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:get/get.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    print("EtudiantBinding dependencies called"); // Debug print
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    Get.lazyPut<JustificationApiServiceImplJson>(() => JustificationApiServiceImplJson());
    Get.put<EtudiantProvider>(EtudiantProvider(Get.find(), Get.find<JustificationApiServiceImplJson>()));
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}


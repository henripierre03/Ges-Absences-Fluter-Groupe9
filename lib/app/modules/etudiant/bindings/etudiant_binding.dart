import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:get/get.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceImplJson());
    Get.lazyPut<EtudiantController>(() => EtudiantController());
  }
}

import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/qr_code_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/absence_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/qr_code_api_service.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';

class EtudiantBinding extends Bindings {
  @override
  void dependencies() {
    // Register the services
    Get.lazyPut<IEtudiantApiService>(() => EtudiantApiServiceSpring());
    Get.lazyPut<IAbsenceService>(() => AbsenceApiServiceSpring());
    Get.lazyPut<JustificationApiServiceImplJson>(
      () => JustificationApiServiceImplJson(),
    );
    Get.lazyPut<IQRCodeService>(() => QrCodeApiServiceSpring());

    // Register the controller
    Get.lazyPut<EtudiantController>(() => EtudiantController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

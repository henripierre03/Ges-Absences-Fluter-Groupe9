import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/providers/etudiant_provider.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:get/get.dart';

class EtudiantController extends GetxController {
  final IEtudiantApiService apiEtudiant = Get.find();

  var etudiants = <Etudiant>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // etudiantProvider.fetchEtudiants();
  }
  Future<void> createJustificationAndUpdateAbsence(
      JustificationCreateRequestDto justification, String absenceId) async {
    await etudiantProvider.createJustificationAndUpdateAbsence(justification, absenceId);
  }
}

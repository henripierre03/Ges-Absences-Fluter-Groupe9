import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';
import 'package:hive/hive.dart';

class EtudiantController extends GetxController {
  final IAbsenceService _absenceService = Get.find<IAbsenceService>();
  final IEtudiantApiService _etudiantService = Get.find<IEtudiantApiService>();

  var absences = <AbsenceSimpleResponseDto>[].obs;
  var etudiant = Rxn<Etudiant>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box('authBox');
    fetchEtudiantData();
  }

  Future<void> fetchEtudiantData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final matricule = authBox.get('matricule');
      if (matricule == null) {
        errorMessage.value = 'Matricule introuvable dans la box Hive';
        return;
      }

      // Récupère les infos de l’étudiant
      final etudiantResponse = await _etudiantService.getEtudiantByMatricule(
        matricule,
      );
      final etudiantId = etudiantResponse.id;

      // Charge les absences associées
      final absencesList = await _absenceService.getAbsencesByEtudiantId(
        etudiantId,
      );
      if (absencesList.isEmpty) {
        errorMessage.value = 'Aucune absence trouvée pour cet étudiant';
      }

      absences.assignAll(absencesList);
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement: ${e.toString()}';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchEtudiantData();
  }
}

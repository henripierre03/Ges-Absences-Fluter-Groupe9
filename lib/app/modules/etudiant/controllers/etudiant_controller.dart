import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
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
    fetchEtudiants();
  }

  Future<void> fetchEtudiants() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      final fetchedEtudiants = await apiEtudiant.getEtudiants();
      etudiants.value = fetchedEtudiants;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      etudiants.value = [];
      Get.snackbar(
        'Erreur',
        'Impossible de récupérer les étudiants',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

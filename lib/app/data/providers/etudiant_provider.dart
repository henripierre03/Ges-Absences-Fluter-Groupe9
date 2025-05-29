import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:get/get.dart';

class EtudiantProvider extends GetxController {
  final IEtudiantApiService apiEtudiant;

  EtudiantProvider(this.apiEtudiant);

  var etudiants = <Etudiant>[].obs;
  var isLoading = false.obs;

  Future<void> fetchEtudiants() async {
    try {
      isLoading.value = true;
      etudiants.value = await apiEtudiant.getEtudiants();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

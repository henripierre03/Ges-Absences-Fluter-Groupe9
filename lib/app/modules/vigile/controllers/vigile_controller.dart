import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/snackbar_utils.dart';
import 'package:frontend_gesabsence/app/widgets/student_info_dialog.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
class VigileController extends GetxController {
  final IEtudiantApiService etudiantApiService;
  VigileController({required this.etudiantApiService});

  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = false.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void handleQRScan(String qrResult) {
    searchController.text = qrResult;
    searchStudentByMatricule(qrResult);
  }

  void clearSearch() => searchController.clear();

  Future<void> markStudentPresence(String matricule, int vigileId) async {
    if (matricule.isEmpty) {
      showErrorSnackbar('Matricule invalide');
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      showSuccessSnackbar('Présence enregistrée pour l\'étudiant $matricule');
      clearSearch();
    } catch (e) {
      showErrorSnackbar('Erreur lors de l\'enregistrement de la présence');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchStudentByMatricule(String matricule) async {
    if (matricule.trim().isEmpty) {
      showErrorSnackbar('Veuillez entrer un matricule');
      return;
    }

    try {
      isSearching.value = true;
      final student = await etudiantApiService.getEtudiantByMatricule(matricule.trim().toUpperCase());

      showStudentInfoPopup(
        student
      );

      showSuccessSnackbar('Étudiant trouvé: ${student.prenom} ${student.nom}');
    } catch (e) {
      String errorMsg;
      if (e.toString().contains('non trouvé')) {
        errorMsg = 'Aucun étudiant trouvé avec ce matricule';
      } else if (e.toString().contains('connexion')) {
        errorMsg = 'Erreur de connexion au serveur';
      } else {
        errorMsg = 'Erreur lors de la recherche';
      }
      showErrorSnackbar(errorMsg);
    } finally {
      isSearching.value = false;
    }
  }
}

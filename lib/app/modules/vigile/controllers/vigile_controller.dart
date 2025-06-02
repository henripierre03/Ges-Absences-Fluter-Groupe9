import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:get/get.dart';

class VigileController extends GetxController {
  final IEtudiantApiService etudiantApiService;

  VigileController({required this.etudiantApiService});

  // Controllers pour les champs de saisie
  final TextEditingController searchController = TextEditingController();

  // Variables observables
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final Rxn<EtudiantSimpleResponse> foundStudent =
      Rxn<EtudiantSimpleResponse>();
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Méthode pour rechercher un étudiant par matricule
  Future<void> searchStudentByMatricule(String matricule) async {
    if (matricule.trim().isEmpty) {
      _showErrorSnackbar('Veuillez entrer un matricule');
      return;
    }

    try {
      isSearching.value = true;
      errorMessage.value = '';
      foundStudent.value = null;

      print('Recherche de l\'étudiant avec matricule: ${matricule.trim()}');

      final student = await etudiantApiService.getEtudiantByMatricule(
        matricule.trim(),
      );

      print('Étudiant trouvé: ${student.toString()}');

      foundStudent.value = student;

      _showSuccessSnackbar('Étudiant trouvé: ${student.prenom} ${student.nom}');
    } catch (e) {
      print('Erreur lors de la recherche: $e');

      errorMessage.value = e.toString();
      foundStudent.value = null;

      _showErrorSnackbar('Étudiant non trouvé ou erreur de connexion');
    } finally {
      isSearching.value = false;
    }
  }

  // Méthode pour gérer le scan QR
  void handleQRScan(String qrResult) {
    print('QR Code scanné: $qrResult');

    // Supposons que le QR code contient le matricule de l'étudiant
    searchController.text = qrResult;
    searchStudentByMatricule(qrResult);
  }

  // Méthode pour effacer la recherche
  void clearSearch() {
    searchController.clear();
    foundStudent.value = null;
    errorMessage.value = '';
  }

  // Méthode pour pointer un étudiant
  Future<void> markStudentPresence(String matricule, int vigileId) async {
    if (matricule.isEmpty) {
      _showErrorSnackbar('Matricule invalide');
      return;
    }

    try {
      isLoading.value = true;

      // Ici vous pouvez implémenter la logique de pointage
      // En utilisant l'API de pointage si elle existe

      // Simulation d'un appel API
      await Future.delayed(const Duration(milliseconds: 500));

      _showSuccessSnackbar('Présence enregistrée pour l\'étudiant $matricule');

      // Optionnellement, effacer la recherche après le pointage
      clearSearch();
    } catch (e) {
      print('Erreur lors du pointage: $e');
      _showErrorSnackbar('Erreur lors de l\'enregistrement de la présence');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthodes utilitaires pour les snackbars
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Succès',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}

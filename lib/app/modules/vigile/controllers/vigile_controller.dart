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
  void onInit() {
    super.onInit();
    print('VigileController initialisé');
    print('Service API: ${etudiantApiService.runtimeType}');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Méthode pour rechercher un étudiant par matricule
  Future<void> searchStudentByMatricule(String matricule) async {
    print('=== DÉBUT searchStudentByMatricule ===');
    print('Matricule reçu: "$matricule"');
    print('Service utilisé: ${etudiantApiService.runtimeType}');

    if (matricule.trim().isEmpty) {
      print('Matricule vide');
      _showErrorSnackbar('Veuillez entrer un matricule');
      return;
    }

    try {
      isSearching.value = true;
      errorMessage.value = '';
      foundStudent.value = null;

      print('Recherche de l\'étudiant avec matricule: "${matricule.trim()}"');
      print('Appel du service API...');

      final student = await etudiantApiService.getEtudiantByMatricule(
        matricule.trim(),
      );

      print('Étudiant trouvé: ${student.toString()}');
      print('Validation: ${student.isValid()}');

      foundStudent.value = student;
      _showSuccessSnackbar('Étudiant trouvé: ${student.prenom} ${student.nom}');
    } catch (e, stackTrace) {
      print('=== ERREUR CAPTURÉE ===');
      print('Exception: $e');
      print('Type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');

      // Gestion spécifique des erreurs
      String errorMsg;
      if (e is UnimplementedError) {
        errorMsg = 'Méthode non implémentée: ${e.message}';
        print('UnimplementedError détecté: ${e.message}');
      } else if (e.toString().contains('non trouvé')) {
        errorMsg = 'Aucun étudiant trouvé avec ce matricule';
      } else if (e.toString().contains('connexion') ||
          e.toString().contains('réseau') ||
          e.toString().contains('Impossible de joindre')) {
        errorMsg = 'Erreur de connexion au serveur';
      } else {
        errorMsg = 'Erreur lors de la recherche: ${e.toString()}';
      }

      errorMessage.value = errorMsg;
      foundStudent.value = null;
      _showErrorSnackbar(errorMsg);
    } finally {
      isSearching.value = false;
      print('=== FIN searchStudentByMatricule ===');
    }
  }

  // Méthode pour gérer le scan QR
  void handleQRScan(String qrResult) {
    print('QR Code scanné: $qrResult');
    searchController.text = qrResult;
    searchStudentByMatricule(qrResult);
  }

  // Méthode pour effacer la recherche
  void clearSearch() {
    print('Clearing search...');
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
      print('Marquage présence pour: $matricule, vigile: $vigileId');

      // Simulation d'un appel API
      await Future.delayed(const Duration(milliseconds: 500));

      _showSuccessSnackbar('Présence enregistrée pour l\'étudiant $matricule');
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

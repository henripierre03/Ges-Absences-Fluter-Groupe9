import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/widgets/student_info_dialog.dart';
import 'package:get/get.dart';

class VigileController extends GetxController {
  late TextEditingController searchController;
  final IEtudiantApiService etudiantApiService;

  // Observable pour l'état de chargement
  final isLoading = false.obs;

  VigileController({required this.etudiantApiService});

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> searchStudent(String matricule) async {
    if (matricule.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer un matricule',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final List<Etudiant> etudiants = await etudiantApiService
          .getEtudiantByMatricule(matricule.trim());

      if (etudiants.isNotEmpty) {
        final etudiant = etudiants.first;
        showStudentInfoPopup(etudiant);
      } else {
        Get.snackbar(
          'Aucun résultat',
          'Aucun étudiant trouvé avec le matricule: $matricule',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la recherche: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      print('Erreur dans searchStudent: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void handleQRScan(String qrData) {
    print('QR Code scanné: $qrData');
    searchController.text = qrData;
    searchStudent(qrData);
  }
}

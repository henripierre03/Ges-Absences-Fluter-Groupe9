import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/snackbar_utils.dart';
import 'package:frontend_gesabsence/app/widgets/student_info_dialog.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:hive/hive.dart';

class VigileController extends GetxController {
  final IEtudiantApiService etudiantApiService;
  final IAbsenceService absenceService;
  late Box authBox;

  VigileController({
    required this.etudiantApiService,
    required this.absenceService,
  }) {
    authBox = Hive.box('authBox');
  }

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

  Future<void> searchStudentByMatricule(String matricule) async {
    if (matricule.trim().isEmpty) {
      showErrorSnackbar('Veuillez entrer un matricule');
      return;
    }

    try {
      isSearching.value = true;

      final String vigileId = authBox.get('userId').toString();

      final pointage = PointageRequestDto(
        matricule: matricule.trim().toUpperCase(),
        vigileId: vigileId,
        date: DateTime.now(),
      );

      final response = await etudiantApiService.pointageEtudiant(pointage);

      if (response.etudiant != null) {
        showStudentInfoPopup(response.etudiant!);
        showSuccessSnackbar(
          'Présence enregistrée: ${response.etudiant!.prenom} ${response.etudiant!.nom}',
        );
      } else {
        showErrorSnackbar('Aucun étudiant trouvé avec ce matricule');
      }
      clearSearch();
    } catch (e) {
      String errorMsg = 'Erreur lors du pointage';

      if (e.toString().contains('déjà pointé')) {
        errorMsg = 'Cet étudiant a déjà été pointé pour ce cours';
      } else if (e.toString().contains('pas encore payé')) {
        errorMsg = 'L’étudiant n’a pas payé pour ce mois';
      } else if (e.toString().contains('non trouvé')) {
        errorMsg = 'Aucun étudiant trouvé avec ce matricule';
      } else if (e.toString().contains(
        "Étudiant n'a pas de cours aujourd'hui",
      )) {
        errorMsg = "L'étudiant n'a pas de cours prévu aujourd'hui";
      } else {
        errorMsg = 'Erreur lors du pointage : ${e.toString()}';
      }

      showErrorSnackbar(errorMsg);
    } finally {
      isSearching.value = false;
    }
  }
}

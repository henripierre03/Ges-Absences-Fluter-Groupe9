import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';

class EtudiantController extends GetxController {
  final IAbsenceService _absenceService = Get.find<IAbsenceService>();
  final IEtudiantApiService _etudiantService = Get.find<IEtudiantApiService>();

  // Observable variables
  var absences = <Absence>[].obs;
  var etudiant = Rxn<Etudiant>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final etudiantId = arguments['etudiantId'];
      if (etudiantId != null) {
        fetchEtudiantData(etudiantId);
      }
    }
  }

  /// Récupère les données de l'étudiant et ses absences
  Future<void> fetchEtudiantData(dynamic etudiantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Récupérer les informations de l'étudiant
      if (etudiantId is int) {
        etudiant.value = await _etudiantService.getEtudiantById(etudiantId);
      } else if (etudiantId is String) {
        // Si c'est un matricule
        final etudiantResponse = await _etudiantService.getEtudiantByMatricule(
          etudiantId,
        );
        // Vous devrez adapter cette partie selon votre modèle Etudiant
        etudiant.value = Etudiant.fromJson(etudiantResponse.toJson());
      }

      // Récupérer les absences de l'étudiant
      await fetchAbsencesByEtudiantId(etudiantId);
    } catch (e) {
      errorMessage.value =
          'Erreur lors du chargement des données: ${e.toString()}';
      print('Erreur fetchEtudiantData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Récupère les absences d'un étudiant par son ID
  Future<void> fetchAbsencesByEtudiantId(dynamic etudiantId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String stringId = etudiantId.toString();
      List<Absence> fetchedAbsences = await _absenceService
          .getAbsencesByEtudiantId(stringId);

      absences.value = fetchedAbsences;
    } catch (e) {
      errorMessage.value =
          'Erreur lors du chargement des absences: ${e.toString()}';
      print('Erreur fetchAbsencesByEtudiantId: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Rafraîchit les données
  Future<void> refreshData() async {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final etudiantId = arguments['etudiantId'];
      if (etudiantId != null) {
        await fetchAbsencesByEtudiantId(etudiantId);
      }
    }
  }
}

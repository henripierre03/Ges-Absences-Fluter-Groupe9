
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:get/get.dart';

class EtudiantController extends GetxController {
  final IEtudiantApiService apiEtudiant = Get.find();
  final JustificationApiServiceImplJson justificationApiService = Get.find();

  var absences = <Absence>[].obs;
  var etudiant = Rxn<Etudiant>();
  var etudiants = <Etudiant>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      final etudiantId = arguments['etudiantId'];
      fetchEtudiantData(etudiantId);
    }else if (arguments != null && arguments is int) {
      fetchEtudiants();
    } else {
      Get.snackbar('Error', 'No student ID provided');
    }
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

  Future<void> fetchEtudiantData(int etudiantId) async {
    try {
      isLoading.value = true;
      
      // Fetch both student data and absences
      final fetchedEtudiant = await apiEtudiant.getEtudiantById(etudiantId);
      final fetchedAbsences = await apiEtudiant.getAbsencesByEtudiantId(etudiantId);
      print('✅ Fetched ${fetchedAbsences.length} absences for student ID $etudiantId');

      etudiant.value = fetchedEtudiant;
      absences.assignAll(fetchedAbsences);
      
    } catch (e) {
      errorMessage.value = 'Failed to load student data: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAbsencesByEtudiantId(int etudiantId) async {
    try {
      isLoading.value = true;
      var fetchedAbsences = await apiEtudiant.getAbsencesByEtudiantId(etudiantId);
      absences.assignAll(fetchedAbsences);
    } catch (e) {
      errorMessage.value = 'Failed to load absences: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createJustificationAndUpdateAbsence(
      JustificationCreateRequestDto justification, int absenceId) async {
    try {
      final justificationResponse = await justificationApiService.createJustification(justification);
      final currentAbsence = await justificationApiService.getAbsenceById(absenceId);
      await justificationApiService.updateAbsence(absenceId, {
        "id": currentAbsence?.id,
        "etudiantId": currentAbsence?.etudiantId,
        "date": currentAbsence?.date,
        "absence": "justifiee",
        "justificationId": justificationResponse.id,
        "coursId": currentAbsence?.coursId,
        
      });

      // Refresh the absences list to reflect the changes
      // if (etudiant.value != null) {
      //   await fetchAbsencesByEtudiantId(etudiant.value!.id);
      // }

      Get.snackbar('Success', 'Justification submitted successfully');
    } catch (e) {
      errorMessage.value = 'Failed to create justification: $e';
      Get.snackbar('Error', errorMessage.value);
      rethrow;
    }
  }

  // New method to get justification by ID
  Future<dynamic> getJustificationById(int justificationId) async {
    try {
      return await justificationApiService.getJustificationByEtudiantId(justificationId);
    } catch (e) {
      errorMessage.value = 'Failed to load justification: $e';
      Get.snackbar('Error', errorMessage.value);
      rethrow;
    }
  }

  // New method to update existing justification
  Future<void> updateJustification(int justificationId, Map<String, dynamic> data) async {
    try {
      await justificationApiService.updateJustification(justificationId, data);
      
      // Refresh the absences list to reflect the changes
      if (etudiant.value != null) {
        await fetchAbsencesByEtudiantId(etudiant.value!.id);
      }
      
      Get.snackbar('Success', 'Justification updated successfully');
    } catch (e) {
      errorMessage.value = 'Failed to update justification: $e';
      Get.snackbar('Error', errorMessage.value);
      rethrow;
    }
  }

  // Getter for easy access to matricule
  String get matricule => etudiant.value?.matricule ?? '';
}
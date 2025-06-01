// import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
// import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
// import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart'; // Add this import
// import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
// import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
// import 'package:get/get.dart';

// class EtudiantController extends GetxController {
//   final IEtudiantApiService apiEtudiant = Get.find();
//   final JustificationApiServiceImplJson justificationApiService = Get.find();

//   var absences = <Absence>[].obs;
//   var etudiant = Rxn<Etudiant>(); // Add this line to store the student data
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final arguments = Get.arguments;
//     if (arguments != null && arguments is Map<String, dynamic>) {
//       final etudiantId = arguments['etudiantId'];
//       fetchEtudiantData(etudiantId);
//     }
//   }

//   Future<void> fetchEtudiantData(String etudiantId) async {
//     try {
//       isLoading.value = true;
      
//       // Fetch both student data and absences
//       final fetchedEtudiant = await apiEtudiant.getEtudiantById(etudiantId);
//       final fetchedAbsences = await apiEtudiant.getAbsencesByEtudiantId(etudiantId);
      
//       etudiant.value = fetchedEtudiant;
//       absences.assignAll(fetchedAbsences);
      
//     } catch (e) {
//       errorMessage.value = 'Failed to load student data: $e';
//       Get.snackbar('Error', errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchAbsencesByEtudiantId(String etudiantId) async {
//     try {
//       isLoading.value = true;
//       var fetchedAbsences = await apiEtudiant.getAbsencesByEtudiantId(etudiantId);
//       absences.assignAll(fetchedAbsences);
//     } catch (e) {
//       errorMessage.value = 'Failed to load absences: $e';
//       Get.snackbar('Error', errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> createJustificationAndUpdateAbsence(
//       JustificationCreateRequestDto justification, String absenceId) async {
//     try {
//       final justificationResponse = await justificationApiService.createJustification(justification);
//       await justificationApiService.updateAbsence(absenceId, {
//         "absence": "justifiee",
//         "justificationId": justificationResponse.id,
//       });
//       Get.snackbar('Success', 'Justification submitted successfully');
//     } catch (e) {
//       errorMessage.value = 'Failed to create justification: $e';
//       Get.snackbar('Error', errorMessage.value);
//     }
//   }

//   // Getter for easy access to matricule
//   String get matricule => etudiant.value?.matricule ?? '';
// }




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
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      final etudiantId = arguments['etudiantId'];
      fetchEtudiantData(etudiantId);
    }
  }

  Future<void> fetchEtudiantData(String etudiantId) async {
    try {
      isLoading.value = true;
      
      // Fetch both student data and absences
      final fetchedEtudiant = await apiEtudiant.getEtudiantById(etudiantId);
      final fetchedAbsences = await apiEtudiant.getAbsencesByEtudiantId(etudiantId);
      
      etudiant.value = fetchedEtudiant;
      absences.assignAll(fetchedAbsences);
      
    } catch (e) {
      errorMessage.value = 'Failed to load student data: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAbsencesByEtudiantId(String etudiantId) async {
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
      JustificationCreateRequestDto justification, String absenceId) async {
    try {
      final justificationResponse = await justificationApiService.createJustification(justification);
      await justificationApiService.updateAbsence(absenceId, {
        "absence": "justifiee",
        "justificationId": justificationResponse.id,
      });
      
      // Refresh the absences list to reflect the changes
      if (etudiant.value != null) {
        await fetchAbsencesByEtudiantId(etudiant.value!.id);
      }
      
      Get.snackbar('Success', 'Justification submitted successfully');
    } catch (e) {
      errorMessage.value = 'Failed to create justification: $e';
      Get.snackbar('Error', errorMessage.value);
      rethrow;
    }
  }

  // New method to get justification by ID
  Future<dynamic> getJustificationById(String justificationId) async {
    try {
      return await justificationApiService.getJustificationByEtudiantId(justificationId);
    } catch (e) {
      errorMessage.value = 'Failed to load justification: $e';
      Get.snackbar('Error', errorMessage.value);
      rethrow;
    }
  }

  // New method to update existing justification
  Future<void> updateJustification(String justificationId, Map<String, dynamic> data) async {
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
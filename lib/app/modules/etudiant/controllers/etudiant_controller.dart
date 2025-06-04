import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/qr_code_service.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

class EtudiantController extends GetxController {
  final IAbsenceService _absenceService = Get.find<IAbsenceService>();
  final IEtudiantApiService _etudiantService = Get.find<IEtudiantApiService>();
  final IQRCodeService _qrCodeService = Get.find<IQRCodeService>();

  var absences = <AbsenceSimpleResponseDto>[].obs;
  var etudiantInfo = Rxn<EtudiantSimpleResponse>();
  var qrCodeImage = Rxn<Uint8List>();
  var isLoading = false.obs;
  var isLoadingQrCode = false.obs;
  var errorMessage = ''.obs;
  var qrCodeErrorMessage = ''.obs;

  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box('authBox');
    fetchEtudiantData();
    fetchQrCode();
  }

  Future<void> fetchEtudiantData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final matricule = authBox.get('matricule');
      if (matricule == null) {
        errorMessage.value = 'Matricule introuvable dans la box Hive';
        return;
      }
      final etudiantResponse = await _etudiantService.getEtudiantByMatricule(
        matricule,
      );
      etudiantInfo.value = etudiantResponse;
      final etudiantId = etudiantResponse.id;
      try {
        final absencesList = await _absenceService.getAbsencesByEtudiantId(
          etudiantId,
        );
        absences.assignAll(absencesList);
      } catch (e) {
        if (e.toString().contains('404')) {
          print('Aucune absence trouvée pour l\'étudiant $etudiantId (404)');
          absences.clear();
        } else {
          errorMessage.value =
              'Erreur lors du chargement des absences: ${e.toString()}';
          print('Erreur dans fetchEtudiantData (absences): $e');
          throw e;
        }
      }
    } catch (e) {
      if (!e.toString().contains('404')) {
        errorMessage.value = 'Erreur lors du chargement: ${e.toString()}';
      }
      print('Erreur dans fetchEtudiantData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // méthode pour charger le QR code
  Future<void> fetchQrCode() async {
    try {
      isLoadingQrCode.value = true;
      qrCodeErrorMessage.value = '';

      final matricule = authBox.get('matricule');
      if (matricule == null) {
        qrCodeErrorMessage.value = 'Matricule introuvable';
        return;
      }

      final qrImage = await _qrCodeService.getQrCode(matricule);
      qrCodeImage.value = qrImage;
    } catch (e) {
      qrCodeErrorMessage.value = 'Erreur lors du chargement du QR Code';
      print('Erreur QR code: $e');
    } finally {
      isLoadingQrCode.value = false;
    }
  }

  // Méthode pour rafraîchir le QR code
  Future<void> refreshQrCode() async {
    await fetchQrCode();
  }

  Future<void> refreshData() async {
    await Future.wait([fetchEtudiantData(), fetchQrCode()]);
  }
}

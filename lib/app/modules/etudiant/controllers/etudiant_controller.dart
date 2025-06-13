import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/qr_code_service.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class EtudiantController extends GetxController {
  final IAbsenceService _absenceService = Get.find<IAbsenceService>();
  final IEtudiantApiService _etudiantService = Get.find<IEtudiantApiService>();
  final IQRCodeService _qrCodeService = Get.find<IQRCodeService>();
  final IJustificationApiService _justificationService =
      Get.find<IJustificationApiService>();

  var absences = <AbsenceSimpleResponseDto>[].obs;
  var etudiantInfo = Rxn<EtudiantSimpleResponse>();
  var qrCodeImage = Rxn<Uint8List>();
  var isLoading = false.obs;
  var isLoadingQrCode = false.obs;
  var isSubmittingJustification = false.obs;
  var errorMessage = ''.obs;
  var qrCodeErrorMessage = ''.obs;

  // Variables pour la justification
  late TextEditingController messageController;
  var selectedFiles = <File>[].obs;

  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box('authBox');
    messageController = TextEditingController();
    fetchEtudiantData();
    fetchQrCode();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
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
          rethrow;
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

  // Méthode pour sélectionner des fichiers
  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        selectedFiles.addAll(files);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la sélection des fichiers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour supprimer un fichier
  void removeFile(File file) {
    selectedFiles.remove(file);
    update();
  }

  Future<void> submitJustification(String absenceId) async {
    try {
      // Validation
      if (messageController.text.trim().isEmpty) {
        Get.snackbar(
          'Champ requis',
          'Veuillez saisir un message de justification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (etudiantInfo.value == null) {
        Get.snackbar(
          'Erreur',
          'Informations étudiant non disponibles',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isSubmittingJustification.value = true;

      print('Envoi justification pour absence: $absenceId');
      print('Etudiant ID: ${etudiantInfo.value!.id}');
      print('Message: ${messageController.text.trim()}');
      print('Nombre de fichiers: ${selectedFiles.length}');

      // Appel au service de justification
      final result = await _justificationService.create(
        absenceId: absenceId,
        files: selectedFiles,
        etudiantId: etudiantInfo.value!.id,
        message: messageController.text.trim(),
        validation: false,
      );

      print('Justification créée avec succès: ${result.id}');

      // Succès
      Get.back(); // Fermer la popup
      Get.snackbar(
        'Succès',
        'Votre justification a été envoyée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Réinitialiser les champs
      messageController.clear();
      selectedFiles.clear();

      // Rafraîchir les données
      await fetchEtudiantData();
    } on FormatException catch (e) {
      Get.snackbar(
        'Erreur de format',
        'Réponse invalide du serveur: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Erreur de format submitJustification: $e');
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'envoi de la justification';
      Color backgroundColor = Colors.red;

      // Gérer les erreurs spécifiques
      if (e.toString().contains('409') || e.toString().contains('CONFLICT')) {
        errorMessage = 'Une justification existe déjà pour cette absence';
        backgroundColor = Colors.orange;
      } else if (e.toString().contains('Une justification existe déjà')) {
        errorMessage = 'Une justification existe déjà pour cette absence';
        backgroundColor = Colors.orange;
      }

      Get.snackbar(
        'Information',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white,
      );
      print('Erreur submitJustification: $e');
    } finally {
      isSubmittingJustification.value = false;
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

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

import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _imagePicker = ImagePicker();

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

  Future<void> takePhoto() async {
    try {
      final String? choice = await Get.dialog<String>(
        AlertDialog(
          title: const Text('Choisir une option'),
          content: const Text('Comment souhaitez-vous ajouter votre photo ?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: 'cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Get.back(result: 'gallery'),
              child: const Text('Galerie'),
            ),
            TextButton(
              onPressed: () => Get.back(result: 'camera'),
              child: const Text('Appareil photo'),
            ),
          ],
        ),
      );

      if (choice == null || choice == 'cancel') return;

      XFile? image;

      if (choice == 'camera') {
        image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxWidth: 1920,
          maxHeight: 1080,
        );
      } else if (choice == 'gallery') {
        // Sélectionner depuis la galerie
        image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1920,
          maxHeight: 1080,
        );
      }

      if (image != null) {
        File photoFile = File(image.path);
        selectedFiles.add(photoFile);
        update();

        Get.snackbar(
          'Succès',
          'Photo ajoutée avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de la prise de photo';

      if (e.toString().contains('camera_access_denied')) {
        errorMessage =
            'Accès à l\'appareil photo refusé. Veuillez autoriser l\'accès dans les paramètres.';
      } else if (e.toString().contains('photo_access_denied')) {
        errorMessage =
            'Accès à la galerie refusé. Veuillez autoriser l\'accès dans les paramètres.';
      }

      Get.snackbar(
        'Erreur',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      print('Erreur takePhoto: $e');
    }
  }

  void removeFile(File file) {
    selectedFiles.remove(file);
    update();
  }

  Future<void> submitJustification(String absenceId) async {
    try {
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

      final result = await _justificationService.create(
        absenceId: absenceId,
        files: selectedFiles,
        etudiantId: etudiantInfo.value!.id,
        message: messageController.text.trim(),
        validation: false,
      );

      print('Justification créée avec succès: ${result.id}');

      Get.back();
      Get.snackbar(
        'Succès',
        'Votre justification a été envoyée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      messageController.clear();
      selectedFiles.clear();

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

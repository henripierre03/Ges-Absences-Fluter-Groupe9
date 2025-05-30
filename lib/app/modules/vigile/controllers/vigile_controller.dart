import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VigileController extends GetxController {
  late TextEditingController searchController;
  final count = 0.obs;
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

  // Méthode pour rechercher un étudiant par matricule
  void searchStudent(String matricule) {
    // Implémentez votre logique de recherche ici
    print('Recherche étudiant avec matricule: $matricule');

    // Exemple d'appel API
    // try {
    //   final student = await studentService.getStudentByMatricule(matricule);
    //   // Traiter le résultat
    // } catch (e) {
    //   Get.snackbar('Erreur', 'Étudiant non trouvé');
    // }
  }

  void handleQRScan(String qrData) {
    // Traiter les données du QR code
    print('QR Code scanné: $qrData');

    // Si le QR contient un matricule, l'utiliser pour la recherche
    searchController.text = qrData;
    searchStudent(qrData);
  }

  void increment() => count.value++;
}

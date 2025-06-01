import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/widgets/student_info_dialog.dart';
import 'package:get/get.dart';

// Classe pour représenter une entrée d'historique
class HistoriqueEntry {
  final Etudiant etudiant;
  final DateTime timestamp;
  final String searchMethod; // 'scan' ou 'search'
  final String matricule;

  HistoriqueEntry({
    required this.etudiant,
    required this.timestamp,
    required this.searchMethod,
    required this.matricule,
  });

  // Méthode pour vérifier si l'entrée est d'aujourd'hui
  bool isToday() {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }
}

class VigileController extends GetxController {
  late TextEditingController searchController;
  final IEtudiantApiService etudiantApiService;

  // Observable pour l'état de chargement
  final isLoading = false.obs;

  // Liste observable pour l'historique des étudiants consultés
  final RxList<HistoriqueEntry> historiqueEtudiants = <HistoriqueEntry>[].obs;

  // Liste observable pour les étudiants d'aujourd'hui uniquement
  final RxList<Etudiant> etudiantsAujourdhui = <Etudiant>[].obs;

  VigileController({required this.etudiantApiService});

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    _loadTodayStudents();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Méthode pour charger les étudiants d'aujourd'hui
  void _loadTodayStudents() {
    final todayEntries = historiqueEtudiants
        .where((entry) => entry.isToday())
        .toList();

    // Éviter les doublons en utilisant un Set basé sur l'ID de l'étudiant
    final uniqueStudents = <int, Etudiant>{};
    for (var entry in todayEntries) {
      uniqueStudents[entry.etudiant.id] = entry.etudiant;
    }

    etudiantsAujourdhui.assignAll(uniqueStudents.values.toList());
  }

  // Méthode pour ajouter un étudiant à l'historique
  void _addToHistorique(Etudiant etudiant, String searchMethod) {
    final entry = HistoriqueEntry(
      etudiant: etudiant,
      timestamp: DateTime.now(),
      searchMethod: searchMethod,
      matricule: etudiant.matricule,
    );

    // Ajouter au début de la liste pour avoir les plus récents en premier
    historiqueEtudiants.insert(0, entry);

    // Limiter l'historique à 100 entrées pour éviter une consommation excessive de mémoire
    if (historiqueEtudiants.length > 100) {
      historiqueEtudiants.removeRange(100, historiqueEtudiants.length);
    }

    // Mettre à jour la liste des étudiants d'aujourd'hui
    _loadTodayStudents();
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

        // Ajouter à l'historique avec la méthode 'search'
        _addToHistorique(etudiant, 'search');

        showStudentInfoPopup(etudiant);

        // Vider le champ de recherche après succès
        searchController.clear();
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

  void handleQRScan(String qrData) async {
    print('QR Code scanné: $qrData');
    searchController.text = qrData;

    // Rechercher l'étudiant et l'ajouter à l'historique avec la méthode 'scan'
    if (qrData.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'QR Code invalide',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final List<Etudiant> etudiants = await etudiantApiService
          .getEtudiantByMatricule(qrData.trim());

      if (etudiants.isNotEmpty) {
        final etudiant = etudiants.first;

        // Ajouter à l'historique avec la méthode 'scan'
        _addToHistorique(etudiant, 'scan');

        showStudentInfoPopup(etudiant);

        // Vider le champ de recherche après succès
        searchController.clear();
      } else {
        Get.snackbar(
          'Aucun résultat',
          'Aucun étudiant trouvé avec le matricule: $qrData',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors du scan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      print('Erreur dans handleQRScan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour obtenir l'historique complet
  List<HistoriqueEntry> get fullHistorique => historiqueEtudiants.toList();

  // Méthode pour obtenir les étudiants d'aujourd'hui
  List<Etudiant> get todayStudents => etudiantsAujourdhui.toList();

  // Méthode pour vider l'historique
  void clearHistorique() {
    historiqueEtudiants.clear();
    etudiantsAujourdhui.clear();
  }

  // Méthode pour obtenir le nombre d'étudiants scannés aujourd'hui
  int get todayScannedCount {
    return historiqueEtudiants
        .where((entry) => entry.isToday() && entry.searchMethod == 'scan')
        .length;
  }

  // Méthode pour obtenir le nombre d'étudiants recherchés aujourd'hui
  int get todaySearchedCount {
    return historiqueEtudiants
        .where((entry) => entry.isToday() && entry.searchMethod == 'search')
        .length;
  }

  // Méthode pour obtenir le nombre total d'étudiants consultés aujourd'hui
  int get todayTotalCount => etudiantsAujourdhui.length;
}

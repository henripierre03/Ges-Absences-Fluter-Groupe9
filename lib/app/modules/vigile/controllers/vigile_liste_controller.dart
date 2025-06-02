import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';

class VigileListController extends GetxController {
  final IAbsenceService absenceService;

  VigileListController({required this.absenceService});

  // Observable pour la liste des absences/pointages
  final RxList<AbsenceAndEtudiantResponse> pointagesList =
      <AbsenceAndEtudiantResponse>[].obs;

  // États de chargement et d'erreur
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // ID du vigile temporaire - à remplacer par l'ID réel une fois la connexion implémentée
  static const String TEMP_VIGILE_ID = "683dfc5d5bfe292c93b191c7";

  // Compteurs pour les statistiques
  final RxInt totalPointages = 0.obs;
  final RxInt pointagesAujourdhui = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadVigilePointages();
  }

  /// Charge la liste des pointages du vigile
  Future<void> loadVigilePointages() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Utilisation de l'ID temporaire - à remplacer par l'ID réel du vigile connecté
      final pointages = await absenceService.getAbsenceByVigile(TEMP_VIGILE_ID);

      pointagesList.value = pointages;
      totalPointages.value = pointages.length;

      // Calculer les pointages d'aujourd'hui
      final today = DateTime.now();
      pointagesAujourdhui.value = pointages.where((pointage) {
        if (pointage.date == null) return false;
        final pointageDate = pointage.date!;
        return pointageDate.year == today.year &&
            pointageDate.month == today.month &&
            pointageDate.day == today.day;
      }).length;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _getErrorMessage(e);
      print('Erreur lors du chargement des pointages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Rafraîchit la liste
  Future<void> refreshPointages() async {
    await loadVigilePointages();
  }

  /// Filtre les pointages par date
  List<AbsenceAndEtudiantResponse> getPointagesByDate(DateTime date) {
    return pointagesList.where((pointage) {
      if (pointage.date == null) return false;
      final pointageDate = pointage.date!;
      return pointageDate.year == date.year &&
          pointageDate.month == date.month &&
          pointageDate.day == date.day;
    }).toList();
  }

  /// Obtient les pointages d'aujourd'hui
  List<AbsenceAndEtudiantResponse> getTodayPointages() {
    return getPointagesByDate(DateTime.now());
  }

  /// Formate la date pour l'affichage
  String formatDate(DateTime? date) {
    if (date == null) return 'Date inconnue';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pointageDay = DateTime(date.year, date.month, date.day);

    if (pointageDay == today) {
      return 'Aujourd\'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (pointageDay == today.subtract(const Duration(days: 1))) {
      return 'Hier à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Obtient le nom complet de l'étudiant
  String getStudentFullName(AbsenceAndEtudiantResponse pointage) {
    final etudiant = pointage.etudiant;
    if (etudiant == null) return 'Étudiant inconnu';
    return '${etudiant.prenom ?? ''} ${etudiant.nom ?? ''}'.trim();
  }

  /// Obtient le matricule de l'étudiant
  String getStudentMatricule(AbsenceAndEtudiantResponse pointage) {
    return pointage.etudiant?.matricule ?? 'Matricule inconnu';
  }

  /// Obtient la couleur selon le type d'absence
  Color getTypeAbsenceColor(String typeAbsence) {
    switch (typeAbsence.toLowerCase()) {
      case 'présent':
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'retard':
        return Colors.orange;
      case 'justifié':
      case 'justifie':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Obtient l'icône selon le type d'absence
  IconData getTypeAbsenceIcon(String typeAbsence) {
    switch (typeAbsence.toLowerCase()) {
      case 'présent':
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'retard':
        return Icons.access_time;
      case 'justifié':
      case 'justifie':
        return Icons.verified;
      default:
        return Icons.help;
    }
  }

  /// Gère les messages d'erreur
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('connexion') || errorStr.contains('network')) {
      return 'Erreur de connexion au serveur';
    } else if (errorStr.contains('timeout')) {
      return 'Délai d\'attente dépassé';
    } else if (errorStr.contains('404')) {
      return 'Aucun pointage trouvé pour ce vigile';
    } else if (errorStr.contains('500')) {
      return 'Erreur serveur interne';
    } else {
      return 'Erreur lors du chargement des données';
    }
  }

  /// Méthode utilitaire pour changer l'ID du vigile (à utiliser une fois la connexion implémentée)
  void updateVigileId(String newVigileId) {
    // Cette méthode sera utile quand vous aurez implémenté l'authentification
    // Pour l'instant, vous devrez modifier la constante TEMP_VIGILE_ID
    print('Mise à jour de l\'ID vigile: $newVigileId');
    // Puis recharger les données
    loadVigilePointages();
  }
}

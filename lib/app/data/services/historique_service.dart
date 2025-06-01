import 'dart:convert';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueService {
  static const String _historiqueKey = 'vigile_historique';

  // Sauvegarder l'historique
  static Future<void> saveHistorique(
    List<Map<String, dynamic>> historique,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String historiqueJson = jsonEncode(historique);
      await prefs.setString(_historiqueKey, historiqueJson);
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'historique: $e');
    }
  }

  // Charger l'historique
  static Future<List<Map<String, dynamic>>> loadHistorique() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historiqueJson = prefs.getString(_historiqueKey);

      if (historiqueJson != null && historiqueJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(historiqueJson);
        return decodedList.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors du chargement de l\'historique: $e');
      return [];
    }
  }

  // Vider l'historique
  static Future<void> clearHistorique() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historiqueKey);
    } catch (e) {
      print('Erreur lors du vidage de l\'historique: $e');
    }
  }

  // Méthode pour convertir HistoriqueEntry en Map
  static Map<String, dynamic> historiqueEntryToMap(HistoriqueEntry entry) {
    return {
      'etudiant': {
        'id': entry.etudiant.id,
        'nom': entry.etudiant.nom,
        'prenom': entry.etudiant.prenom,
        'matricule': entry.etudiant.matricule,
        // Ajoutez d'autres champs nécessaires de votre modèle Etudiant
      },
      'timestamp': entry.timestamp.toIso8601String(),
      'searchMethod': entry.searchMethod,
      'matricule': entry.matricule,
    };
  }

  // Méthode pour convertir Map en HistoriqueEntry
  static HistoriqueEntry mapToHistoriqueEntry(Map<String, dynamic> map) {
    return HistoriqueEntry(
      etudiant: Etudiant(
        id: map['etudiant']['id'],
        nom: map['etudiant']['nom'],
        prenom: map['etudiant']['prenom'],
        matricule: map['etudiant']['matricule'],
        email: map['etudiant']['email'],
        password: map['etudiant']['password'],
        role: map['etudiant']['role'],
        niveau: map['etudiant']['niveau'],
        classeId: map['etudiant']['classeId'],
        qrCode: map['etudiant']['qrCode'],
        // Reconstruire l'objet Etudiant avec les champs nécessaires
      ),
      timestamp: DateTime.parse(map['timestamp']),
      searchMethod: map['searchMethod'],
      matricule: map['matricule'],
    );
  }
}

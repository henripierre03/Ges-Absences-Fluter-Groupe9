import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/vigile_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:http/http.dart' as http;

class LoginApiServiceImplJson extends BaseApiService
    implements ILoginApiService {
  LoginApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final client = http.Client();
    try {
      // Récupère tous les étudiants
      final etudiantResponse = await client
          .get(
            Uri.parse('$baseUrl/etudiants'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (etudiantResponse.statusCode == 200) {
        final List<dynamic> etudiants = json.decode(etudiantResponse.body);

        // Recherche de l'étudiant avec les bonnes credentials
        for (var etudiantData in etudiants) {
          if (etudiantData['email'] == email &&
              etudiantData['password'] == password) {
            final etudiant = Etudiant.fromJson(etudiantData);
            return {'userType': 'etudiant', 'user': etudiant};
          }
        }
      }

      // Si aucun étudiant trouvé, vérifie les vigiles
      final vigileResponse = await client
          .get(
            Uri.parse('$baseUrl/vigiles'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (vigileResponse.statusCode == 200) {
        final List<dynamic> vigiles = json.decode(vigileResponse.body);

        for (var vigileData in vigiles) {
          if (vigileData['email'] == email &&
              vigileData['password'] == password) {
            final vigile = Vigile.fromJson(vigileData);
            return {'userType': 'vigile', 'user': vigile};
          }
        }
      }
      throw Exception('Email ou mot de passe incorrect.');
    } on TimeoutException {
      throw Exception('Délai de connexion dépassé. Veuillez réessayer.');
    } on SocketException {
      throw Exception('Erreur réseau : impossible de se connecter au serveur.');
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    } finally {
      client.close();
    }
  }
}

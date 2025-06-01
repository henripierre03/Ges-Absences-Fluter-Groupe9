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
      // Vérifie l'étudiant
      final etudiantResponse = await client
          .get(
            Uri.parse('$baseUrl/etudiants?email=$email&password=$password'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (etudiantResponse.statusCode == 200) {
        final List<dynamic> etudiants = json.decode(etudiantResponse.body);
        if (etudiants.isNotEmpty) {
          final etudiant = Etudiant.fromJson(etudiants.first);
          return {'userType': 'etudiant', 'user': etudiant};
        }
      }

      // Sinon, vérifie vigile
      final vigileResponse = await client
          .get(
            Uri.parse('$baseUrl/vigiles?email=$email&password=$password'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (vigileResponse.statusCode == 200) {
        final List<dynamic> vigiles = json.decode(vigileResponse.body);
        if (vigiles.isNotEmpty) {
          final vigile = Vigile.fromJson(vigiles.first);
          return {'userType': 'vigile', 'user': vigile};
        }
      }

      throw Exception('Aucun utilisateur trouvé avec ces identifiants.');
    } on TimeoutException catch (_) {
      throw Exception('Délai de connexion dépassé. Veuillez réessayer.');
    } on SocketException catch (_) {
      throw Exception('Erreur réseau : impossible de se connecter au serveur.');
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    } finally {
      client.close();
    }
  }
}

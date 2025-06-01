import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:http/http.dart' as http;

class EtudiantApiServiceImplJson extends BaseApiService implements IEtudiantApiService {
  EtudiantApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<Etudiant> getEtudiantById(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiants/$userId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Etudiant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load student: ${response.statusCode}');
    }
  }

  Future<List<Absence>> getAbsencesByEtudiantId(int etudiantId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/absences/?etudiantId=$etudiantId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print('✅ Fetched ${body.length} absences for student ID $etudiantId');
      return body.map((item) => Absence.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load absences: ${response.statusCode}');
    }
  }

  @override
  Future<List<Etudiant>> getEtudiantByMatricule(String matricule) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/etudiants?matricule=$matricule'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        List<Etudiant> etudiants = [];

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('etudiants')) {
          final List<dynamic> etudiantsData = responseData['etudiants'];
          etudiants = etudiantsData.map((e) => Etudiant.fromJson(e)).toList();
        } else if (responseData is List<dynamic>) {
          etudiants = responseData.map((e) => Etudiant.fromJson(e)).toList();
        }

        return etudiants
            .where((etudiant) => etudiant.matricule == matricule)
            .toList();
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('Erreur dans getEtudiantByMatricule: $e');
      throw Exception('Erreur de recherche d\'étudiant: $e');
    }
  }

   @override
  Future<List<Etudiant>> getEtudiants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/etudiants'));
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('etudiants')) {
          final List<dynamic> etudiantsData = responseData['etudiants'];
          return etudiantsData.map((e) => Etudiant.fromJson(e)).toList();
        } else if (responseData is List<dynamic>) {
          return responseData.map((e) => Etudiant.fromJson(e)).toList();
        } else {
          throw Exception('Format de réponse inattendu');
        }
      } else {
        throw Exception(
          'Erreur de chargement des étudiants: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur dans getEtudiants: $e');
      throw Exception('Erreur de chargement des étudiants: $e');
    }
  }

}


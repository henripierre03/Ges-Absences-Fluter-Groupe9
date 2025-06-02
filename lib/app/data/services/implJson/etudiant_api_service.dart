import 'dart:async';
import 'dart:convert';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';
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

  @override
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

  @override
  Future<List<Etudiant>> getAllEtudiants(User userConnect) {
    // TODO: implement getAllEtudiants
    throw UnimplementedError();
  }

  @override
  Future<Etudiant> getEtudiantByVigileId(PointageRequestDto pointageRequest) {
    // TODO: implement getEtudiantByVigileId
    throw UnimplementedError();
  }

  @override
  Future<EtudiantSimpleResponse> getEtudiantByMatricule(String matricule) {
    // TODO: implement getEtudiantByMatricule
    throw UnimplementedError();
  }

}


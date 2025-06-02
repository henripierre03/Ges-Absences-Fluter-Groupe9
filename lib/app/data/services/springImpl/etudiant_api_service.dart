import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudiantApiServiceSpring implements IEtudiantApiService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<Absence>> getAbsencesByEtudiantId(int etudiantId) async {
    final url = Uri.parse('$baseUrl/api/mobile/absence/etudiant/$etudiantId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data =
            jsonResponse['data'] ?? jsonResponse['result'] ?? [];

        return data.map((e) => Absence.fromJson(e)).toList();
      } else {
        throw Exception(
          'Erreur lors du chargement des absences (code ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception(
        'Erreur réseau lors du chargement des absences: ${e.toString()}',
      );
    }
  }

  @override
  Future<Etudiant> getEtudiantById(int id) async {
    final url = Uri.parse('$baseUrl/api/mobile/etudiant/id/$id');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['result'] ?? data['data'];
        return Etudiant.fromJson(result);
      } else {
        throw Exception(
          'Erreur lors de la récupération de l\'étudiant (code ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception(
        'Erreur réseau lors de la récupération de l\'étudiant: ${e.toString()}',
      );
    }
  }

  @override
  Future<EtudiantSimpleResponse> getEtudiantByMatricule(
    String matricule,
  ) async {
    final url = Uri.parse('$baseUrl/api/mobile/etudiant/$matricule');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['result'] ?? data['data'];
        return EtudiantSimpleResponse.fromJson(result);
      } else {
        throw Exception(
          'Erreur lors de la récupération de l\'étudiant (code ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception(
        'Erreur réseau lors de la récupération de l\'étudiant: ${e.toString()}',
      );
    }
  }

  // Les autres méthodes restent à implémenter selon vos besoins
  @override
  Future<Etudiant> getEtudiantByVigileId(PointageRequestDto pointageRequest) =>
      throw UnimplementedError();

  @override
  Future<List<Etudiant>> getAllEtudiants(User userConnect) =>
      throw UnimplementedError();

  @override
  Future<List<Etudiant>> getEtudiants() => throw UnimplementedError();
}

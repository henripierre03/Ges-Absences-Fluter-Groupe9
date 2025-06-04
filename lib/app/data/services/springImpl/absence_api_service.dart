import 'dart:convert';
import 'package:frontend_gesabsence/app/data/dto/request/absence_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:hive/hive.dart';

class AbsenceApiServiceSpring implements IAbsenceService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> getAuthHeaders() async {
    final authBox = Hive.box('authBox');
    final token = authBox.get('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<AbsenceSimpleResponseDto>> getAbsencesByEtudiantId(
    String etudiantId,
  ) async {
    final url = Uri.parse('$baseUrl/api/mobile/absence/etudiant/$etudiantId');
    try {
      final headers = await getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('result') &&
            jsonResponse['result'] != null) {
          final List<dynamic> data = jsonResponse['result'];
          return data.map((e) => AbsenceSimpleResponseDto.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Erreur lors du chargement des absences (code ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Exception getAbsencesByEtudiantId: $e');
      throw Exception(
        'Erreur réseau lors du chargement des absences: ${e.toString()}',
      );
    }
  }

  @override
  Future<Absence> createAbsence(AbsenceCreateRequestDto absence) async {
    final url = Uri.parse('$baseUrl/api/mobile/absence/create');
    final headers = await getAuthHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(absence.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final absenceJson = responseBody['absence'] as Map<String, dynamic>;
      print('Absence crée ${response.statusCode}: ${response.body}');
      return Absence.fromJson(absenceJson);
    } else if (response.statusCode == 409) {
      print('Erreur ${response.statusCode}: ${response.body}');
      throw Exception('Conflit : cette absence existe déjà.');
    } else if (response.statusCode == 400) {
      print('Erreur ${response.statusCode}: ${response.body}');
      throw Exception('Requête invalide : données manquantes ou incorrectes.');
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
      throw Exception('Erreur serveur : code ${response.statusCode}');
    }
  }

  @override
  Future<List<AbsenceAndEtudiantResponse>> getAbsenceByVigile(
    String vigileId,
  ) async {
    final url = Uri.parse('$baseUrl/api/mobile/absence/vigile/$vigileId');
    try {
      final headers = await getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('result') &&
            jsonResponse['result'] != null) {
          final List<dynamic> data = jsonResponse['result'];
          return data
              .map((e) => AbsenceAndEtudiantResponse.fromJson(e))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Erreur lors du chargement des absences (code ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Exception getAbsenceByVigile: $e');
      throw Exception(
        'Erreur réseau lors du chargement des absences: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Absence>> getAllAbsences() => throw UnimplementedError();
}

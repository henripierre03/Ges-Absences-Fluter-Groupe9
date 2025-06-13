import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudiantApiServiceSpring implements IEtudiantApiService {
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
  Future<EtudiantSimpleResponse> getEtudiantByMatricule(
    String matricule,
  ) async {
    final url = Uri.parse('$baseUrl/api/mobile/etudiant/$matricule');

    try {
      print('URL appelée: $url');

      final response = await http.get(url, headers: await getAuthHeaders());

      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('result') && data['result'] != null) {
          final result = data['result'];
          print('Parsing result: $result');
          return EtudiantSimpleResponse.fromJson(result);
        } else if (data.containsKey('data') && data['data'] != null) {
          final result = data['data'];
          print('Parsing data: $result');
          return EtudiantSimpleResponse.fromJson(result);
        } else {
          print('Trying direct parse: $data');
          return EtudiantSimpleResponse.fromJson(data);
        }
      } else if (response.statusCode == 404) {
        throw Exception('Étudiant avec le matricule $matricule non trouvé');
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Exception détaillée getEtudiantByMatricule: $e');
      print('Exception type: ${e.runtimeType}');

      if (e.toString().contains('non trouvé')) {
        rethrow;
      }
      throw Exception('Erreur de connexion: $e');
    }
  }

  @override
  Future<List<Etudiant>> getAllEtudiants(User userConnect) async {
    final url = Uri.parse('$baseUrl/api/mobile/etudiants');

    try {
      print('Calling: $url');

      final response = await http.get(url, headers: await getAuthHeaders());

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data =
            jsonResponse['data'] ?? jsonResponse['result'] ?? [];

        return data.map((e) => Etudiant.fromJson(e)).toList();
      } else {
        throw Exception(
          'Erreur lors du chargement des étudiants (code ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Exception getAllEtudiants: $e');
      throw Exception(
        'Erreur réseau lors du chargement des étudiants: ${e.toString()}',
      );
    }
  }

  @override
  Future<AbsenceAndEtudiantResponse> pointageEtudiant(
    PointageRequestDto request,
  ) async {
    final url = Uri.parse('$baseUrl/api/mobile/etudiant/pointage');

    try {
      final headers = await getAuthHeaders();
      final body = jsonEncode(request.toJson());

      print('POST $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(url, headers: headers, body: body);

      print('Status code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        final data = jsonResponse['data'] ?? jsonResponse['result'];

        if (data == null) {
          throw Exception("Réponse sans données");
        }

        return AbsenceAndEtudiantResponse.fromJson(data);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final message =
            errorResponse['result'] ??
            errorResponse['message'] ??
            'Erreur inconnue';
        throw Exception('Erreur du serveur : $message');
      }
    } catch (e) {
      print('Erreur pointageEtudiant: $e');
      throw Exception('Erreur lors du pointage de l\'étudiant : $e');
    }
  }
}

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
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
  Future<List<Etudiant>> getEtudiantByMatricule(String matricule) {
    // TODO: implement getEtudiantByMatricule
    throw UnimplementedError();
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

  // Implémentation des autres méthodes pour éviter UnimplementedError
  @override
  Future<Etudiant> getEtudiantByVigileId(
    PointageRequestDto pointageRequest,
  ) async {
    // Implémentation temporaire ou réelle selon vos besoins
    throw UnimplementedError('Cette méthode n\'est pas encore implémentée');
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
}

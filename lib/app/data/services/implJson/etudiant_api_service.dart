import 'dart:convert';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:http/http.dart' as http;

class EtudiantApiServiceImplJson implements IEtudiantApiService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<Etudiant>> getEtudiants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/etudiants'));
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        if (responseData is Map<String, dynamic> && responseData.containsKey('etudiants')) {
          final List<dynamic> etudiantsData = responseData['etudiants'];
          return etudiantsData.map((e) => Etudiant.fromJson(e)).toList();
        } 
        else if (responseData is List<dynamic>) {
          return responseData.map((e) => Etudiant.fromJson(e)).toList();
        } else {
          throw Exception('Format de réponse inattendu');
        }
      } else {
        throw Exception('Erreur de chargement des étudiants: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur dans getEtudiants: $e');
      throw Exception('Erreur de chargement des étudiants: $e');
    }
  }
}
import 'dart:convert';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:http/http.dart' as http;

class EtudiantApiService implements IEtudiantApiService {
  final String baseUrl = ApiConfig.baseUrl;
  
  @override
  Future<List<Etudiant>> getEtudiants() async {
    final response = await http.get(Uri.parse('$baseUrl/etudiants'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Etudiant.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement des étudiants');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getAbsenceById(String absenceId) {
    // TODO: implement getAbsenceById
    throw UnimplementedError();
  }
  
  @override
  Future<Etudiant> getEtudiantByUserId(String id) {
    // TODO: implement getEtudiantByUserId
    throw UnimplementedError();
  }

  @override
  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId) {
    // TODO: implement getAbsencesByEtudiantId
    throw UnimplementedError();
  }
  
  
  
  @override
  Future<List<Absence?>> getAllAbsences() {
    // TODO: implement getAllAbsences
    throw UnimplementedError();
  }
  
  @override
  Future<List<Etudiant>> getAllEtudiants() {
    // TODO: implement getAllEtudiants
    throw UnimplementedError();
  }
  
  @override
  Future<Etudiant> getEtudiantById(String id) {
    // TODO: implement getEtudiantById
    throw UnimplementedError();
  }
  
  
}

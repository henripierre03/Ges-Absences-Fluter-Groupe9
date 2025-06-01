import 'dart:async';
import 'dart:convert';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
import 'package:http/http.dart' as http;

class EtudiantApiServiceImplJson extends BaseApiService implements IEtudiantApiService {
  EtudiantApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<Etudiant> getEtudiantById(String userId) async {
    final allEtudiants = await getAllEtudiants();
    return allEtudiants.firstWhere(
      (etudiant) => etudiant.id == userId,
      orElse: () => throw Exception('Student not found with id: $userId'),
    );
  }
  

  @override
  Future<List<Absence>> getAllAbsences() async {
    final response = await http.get(
      Uri.parse('$baseUrl/absences'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Absence.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load absences: ${response.statusCode}');
    }
  }

  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId) async {
    final allAbsences = await getAllAbsences();
    return allAbsences.where((absence) => absence.etudiantId == etudiantId).toList();
  }
  
  @override
  Future<List<Etudiant>> getAllEtudiants() async {
    final response = await http.get(
      Uri.parse('$baseUrl/etudiants'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }

}


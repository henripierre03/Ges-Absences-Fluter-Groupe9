import 'dart:convert';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';
// import 'package:http/http.dart' as http;

class EtudiantApiServiceImplJson extends BaseApiService implements IEtudiantApiService {
  EtudiantApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  Future<Etudiant> getEtudiantByUserId(String userId) async {
    final response = await client.get(Uri.parse('$baseUrl/etudiants?userId=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      if (body.isNotEmpty) {
        return Etudiant.fromJson(body.first);
      } else {
        throw Exception('No student found with userId: $userId');
      }
    } else {
      throw Exception('Failed to load student with userId: $userId');
    }
  }

  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId) async {
    final response = await client.get(Uri.parse('$baseUrl/absences?etudiantId=$etudiantId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Absence.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load absences for student with id: $etudiantId');
    }
  }
  
}

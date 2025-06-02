import 'dart:convert';
import 'package:frontend_gesabsence/app/data/services/i_absence_service.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';

class AbsenceApiServiceSpring implements IAbsenceService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId) async {
    final url = Uri.parse('$baseUrl/api/mobile/absence/etudiant/$etudiantId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((e) => Absence.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des absences');
    }
  }

  // Les autres méthodes restent à implémenter
  @override
  Future<Absence> createAbsence(Absence absence) => throw UnimplementedError();

  @override
  Future<Absence> getAbsenceByVigile(String vigileId) =>
      throw UnimplementedError();

  @override
  Future<List<Absence>> getAllAbsences() => throw UnimplementedError();
}

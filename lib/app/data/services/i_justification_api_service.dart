// creer ici les interfaces pour les services d'API de justification
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/justification_model.dart';

abstract class IJustificationApiService {
  Future<JustificationCreateRequestDto> createJustification(JustificationCreateRequestDto justification);
  Future<void> updateAbsence(String absenceId, Map<String, dynamic> absenceData);
  Future<void> updateJustification(String justificationId, Map<String, dynamic> data);
  Future<List<Absence?>> getAllAbsences();
  Future<List<Justification?>> getAllJustifications();
  Future<List<Justification?>> getJustificationByEtudiantId(String etudiantId);
}


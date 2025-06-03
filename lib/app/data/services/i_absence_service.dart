import 'package:frontend_gesabsence/app/data/dto/request/absence_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';

abstract class IAbsenceService {
  Future<List<Absence>> getAllAbsences();
  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId);
  Future<Absence> createAbsence(AbsenceCreateRequestDto absence);
  Future<List<AbsenceAndEtudiantResponse>> getAbsenceByVigile(String vigileId);
}

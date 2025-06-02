import 'package:frontend_gesabsence/app/data/models/absence_model.dart';

abstract class IAbsenceService {
  Future<List<Absence>> getAllAbsences();
  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId);
  Future<Absence> createAbsence(Absence absence);
  Future<Absence> getAbsenceByVigile(String vigileId);
}

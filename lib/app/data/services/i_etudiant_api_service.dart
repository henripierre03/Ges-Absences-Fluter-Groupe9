// creer ici les interfaces pour les services d'API de l'étudiant
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';

abstract class IEtudiantApiService {
  Future<Etudiant> getEtudiantByUserId(String id);
  Future<List<Absence>> getAbsencesByEtudiantId(String etudiantId);
  Future<List<Absence?>> getAllAbsences();

}

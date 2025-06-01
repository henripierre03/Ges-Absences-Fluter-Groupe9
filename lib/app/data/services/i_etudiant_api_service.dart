// creer ici les interfaces pour les services d'API de l'étudiant
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';

abstract class IEtudiantApiService {
  Future<Etudiant> getEtudiantById(int id);
  Future<List<Absence>> getAbsencesByEtudiantId(int etudiantId);
  Future<List<Etudiant>> getEtudiantByMatricule(String matricule);
  Future<List<Etudiant>> getEtudiants();
  // Future<List<Absence?>> getAllAbsences();
  // Future<List<Etudiant>> getAllEtudiants();

}

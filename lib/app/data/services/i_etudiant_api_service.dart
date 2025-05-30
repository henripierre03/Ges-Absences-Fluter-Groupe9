// creer ici les interfaces pour les services d'API de l'étudiant
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';

abstract class IEtudiantApiService {
  Future<List<Etudiant>> getEtudiants();
  Future<List<Etudiant>> getEtudiantByMatricule(String matricule);
}

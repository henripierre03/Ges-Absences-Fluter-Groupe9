import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';

abstract class IEtudiantApiService {
  Future<Etudiant> getEtudiantById(int id);
  Future<List<Absence>> getAbsencesByEtudiantId(int etudiantId);
  Future<List<Etudiant>> getEtudiants();
  // ||
  // ||
  // back
  Future<List<Etudiant>> getAllEtudiants(User userConnect);
  Future<EtudiantSimpleResponse> getEtudiantByMatricule(String matricule);
  Future<Etudiant> getEtudiantByVigileId(PointageRequestDto pointageRequest);
}

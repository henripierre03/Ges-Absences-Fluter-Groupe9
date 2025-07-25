import 'package:frontend_gesabsence/app/data/dto/request/pointage_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';
import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';

abstract class IEtudiantApiService {
  // ||
  // ||
  // back
  Future<List<Etudiant>> getAllEtudiants(User userConnect);
  Future<EtudiantSimpleResponse> getEtudiantByMatricule(String matricule);
  Future<AbsenceAndEtudiantResponse> pointageEtudiant(PointageRequestDto request);
}

import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';

abstract class ILoginApiService {
  Future<Etudiant> login(String email, String password);
  Future<List<Etudiant>> getAllEtudiants();
}



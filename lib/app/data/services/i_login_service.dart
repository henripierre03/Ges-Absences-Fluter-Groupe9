import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/vigile_model.dart';

abstract class ILoginApiService {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<List<Etudiant>> getAllEtudiants();
  Future<List<Vigile>> getAllVigiles();
}
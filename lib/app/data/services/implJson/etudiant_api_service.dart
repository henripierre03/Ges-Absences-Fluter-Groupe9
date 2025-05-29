import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_etudiant_api_service.dart';

class EtudiantApiServiceImplJson implements IEtudiantApiService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<Etudiant>> getEtudiants() {
    // TODO: implement getEtudiants
    throw UnimplementedError();
  }
}

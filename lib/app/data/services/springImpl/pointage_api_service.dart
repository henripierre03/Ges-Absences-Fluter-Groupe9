import 'package:frontend_gesabsence/app/data/dto/response/pointage_response.dart';
import 'package:frontend_gesabsence/app/data/services/i_pointage_service.dart';

class JustificationApiService implements IPointageService {
  @override
  Future<List<PointageSimpleResponseDto>> getPointagesByMatricule(String matricule, String date) {
    // TODO: implement getPointagesByMatricule
    throw UnimplementedError();
  }

}

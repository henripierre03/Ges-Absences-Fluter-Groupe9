import 'package:frontend_gesabsence/app/data/dto/response/pointage_response.dart';

abstract class IPointageService {
  Future<List<PointageSimpleResponseDto>> getPointagesByMatricule(
    String matricule,
    String date,
  );
}

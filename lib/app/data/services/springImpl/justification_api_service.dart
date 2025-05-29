import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';
import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';

class JustificationApiService implements IJustificationApiService {
  @override
  Future<JustificationResponseDto> createJustification(JustificationCreateRequestDto justification) {
    // TODO: implement createJustification
    throw UnimplementedError();
  }

  @override
  Future<void> updateAbsence(String absenceId, Map<String, dynamic> absenceData) {
    // TODO: implement updateAbsence
    throw UnimplementedError();
  }
}

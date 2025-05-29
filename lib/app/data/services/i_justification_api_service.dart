// creer ici les interfaces pour les services d'API de justification
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';

abstract class IJustificationApiService {
  Future<JustificationResponseDto> createJustification(
      JustificationCreateRequestDto justification);
  Future<void> updateAbsence(String absenceId, Map<String, dynamic> absenceData);
}


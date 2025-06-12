// creer ici les interfaces pour les services d'API de justification
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';

abstract class IJustificationApiService {
  Future<JustificationCreateRequestDto> createJustification(
    JustificationCreateRequestDto justification,
  );
  Future<void> updateAbsence(int absenceId, Map<String, dynamic> absenceData);
  Future<void> updateJustification(
    int justificationId,
    Map<String, dynamic> data,
  );

  // ||
  // |
  Future<Absence> getAbsenceById(String absenceId);
  Future<Absence> create(
    String absenceId,
    JustificationCreateRequestDto request,
  );
}

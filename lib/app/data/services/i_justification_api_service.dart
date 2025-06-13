import 'dart:io';

import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';

abstract class IJustificationApiService {
  Future<Absence> getAbsenceById(String absenceId);
  Future<JustificationSimpleResponse> create({
    required String absenceId,
    required List<File> files,
    required String etudiantId,
    required String message,
    bool validation = false,
  });
}

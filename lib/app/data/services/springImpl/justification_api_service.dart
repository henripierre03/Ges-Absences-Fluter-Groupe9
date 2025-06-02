import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/justification_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';

class JustificationApiService implements IJustificationApiService {
  @override
  Future<JustificationCreateRequestDto> createJustification(JustificationCreateRequestDto justification) {
    // TODO: implement createJustification
    throw UnimplementedError();
  }

  @override
  Future<List<Absence?>> getAllAbsences() {
    // TODO: implement getAllAbsences
    throw UnimplementedError();
  }

  @override
  Future<List<Justification?>> getAllJustifications() {
    // TODO: implement getAllJustifications
    throw UnimplementedError();
  }

  @override
  Future<List<Justification?>> getJustificationByEtudiantId(int etudiantId) {
    // TODO: implement getJustificationByEtudiantId
    throw UnimplementedError();
  }

  @override
  Future<void> updateAbsence(int absenceId, Map<String, dynamic> absenceData) {
    // TODO: implement updateAbsence
    throw UnimplementedError();
  }

  @override
  Future<void> updateJustification(int justificationId, Map<String, dynamic> data) {
    // TODO: implement updateJustification
    throw UnimplementedError();
  }


  
// ------------------------------------------------------------------------------------------------------------
  @override
  Future<Absence> create(String absenceId, JustificationCreateRequestDto request) {
    // TODO: implement create
    throw UnimplementedError();
  }
  
  @override
  Future<Absence> getAbsenceById(String absenceId) {
    // TODO: implement getAbsenceById
    throw UnimplementedError();
  }

}

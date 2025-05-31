import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceController extends GetxController {
  var absences = <Absence>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsences();
  }

  void loadAbsences() {
    absences.value = [
      Absence(
        id: '1',
        etudiantId: 'etu1',
        date: DateTime(2025, 5, 27),
        absence: TypeAbsence.absence,  
        justificationId: 'just1',
        coursId: 'Flutter 204',
      ),
      Absence(
        id: '2',
        etudiantId: 'etu1',
        date: DateTime(2025, 5, 27),
        absence: TypeAbsence.justifiee,  
        justificationId: 'just2',
        coursId: 'Flutter 204',
      ),
      Absence(
        id: '3',
        etudiantId: 'etu1',
        date: DateTime(2025, 5, 27),
        absence: TypeAbsence.retard,  
        justificationId: 'just3',
        coursId: 'Flutter 204',
      ),
    ];
  }
}

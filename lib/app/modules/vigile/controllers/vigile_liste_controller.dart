import 'package:frontend_gesabsence/app/data/services/springImpl/absence_api_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_and_etudiant_response.dart';

class VigileListeController extends GetxController {
  final AbsenceApiServiceSpring _absenceService = AbsenceApiServiceSpring();

  var absences = <AbsenceAndEtudiantResponse>[].obs;
  var isLoading = false.obs;
  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box('authBox');
    fetchAbsences();
  }

  Future<void> fetchAbsences() async {
    final String? vigileId = authBox.get('userId');
    if (vigileId == null) {
      print("Vigile ID introuvable !");
      return;
    }

    isLoading.value = true;
    try {
      final data = await _absenceService.getAbsenceByVigile(vigileId);
      absences.value = data;
      if (data.isEmpty) {
        print("Aucune absence trouvée pour ce vigile.");
      }
    } catch (e) {
      print("Erreur lors du chargement des absences: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

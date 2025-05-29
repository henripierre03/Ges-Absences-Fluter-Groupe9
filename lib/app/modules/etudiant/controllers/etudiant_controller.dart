import 'package:frontend_gesabsence/app/data/providers/etudiant_provider.dart';
import 'package:get/get.dart';

class EtudiantController extends GetxController {
  final etudiantProvider = Get.find<EtudiantProvider>();

  @override
  void onInit() {
    super.onInit();
    etudiantProvider.fetchEtudiants();
  }
}

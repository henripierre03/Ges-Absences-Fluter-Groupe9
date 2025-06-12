import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthService {
  static void handleInitialRedirect() {
    final authBox = Hive.box('authBox');
    final token = authBox.get('token');
    final role = authBox.get('role');

    if (token == null || role == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    switch (role.toUpperCase()) {
      case 'ETUDIANT':
        Get.offAllNamed(Routes.ETUDIANT);
        break;
      case 'VIGILE':
        Get.offAllNamed(Routes.VIGILE);
        break;
      default:
        Get.offAllNamed(Routes.LOGIN);
        break;
    }
  }
}

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = true.obs;
  var progress = 0.0.obs;
  var statusText = 'Initialisation...'.obs;


  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulation du chargement avec animations
    await _simulateLoading();

    // Vérification de l'authentification et redirection
    await _handleAuthentication();
  }

  Future<void> _simulateLoading() async {
    final steps = [
      'Chargement des ressources...',
      'Configuration de l\'application...',
      'Vérification de l\'authentification...',
      'Finalisation...',
    ];

    for (int i = 0; i < steps.length; i++) {
      statusText.value = steps[i];

      // Animation progressive
      for (int j = 0; j <= 25; j++) {
        progress.value = (i * 25 + j) / 100;
        await Future.delayed(const Duration(milliseconds: 20));
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _handleAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final authBox = Hive.box('authBox');
    final token = authBox.get('token');
    final role = authBox.get('role');

    isLoading.value = false;

    // Attendre un peu pour l'animation finale
    await Future.delayed(const Duration(milliseconds: 800));

    if (token == null || role == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    switch (role.toString().toUpperCase()) {
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

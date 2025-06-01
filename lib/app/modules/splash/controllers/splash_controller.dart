import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToLogin();
  }

  // void _navigateToLogin() async {
  //   await Future.delayed(const Duration(seconds: 3));

  //   Get.offAllNamed(Routes.LOGIN);
  // }

  void _navigateToLogin() async {
    print("Splash: Début du timer de 3 secondes");
    await Future.delayed(const Duration(seconds: 3));
    print("Splash: Navigation vers login");
    Get.offAllNamed(Routes.LOGIN);
  }
}

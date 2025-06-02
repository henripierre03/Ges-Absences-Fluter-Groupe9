import 'package:flutter/widgets.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/vigile_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ILoginApiService loginApiService = Get.find();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading states
  final isLoading = false.obs;

  // User type selection
  final selectedUserType = 'vigile'.obs;

  // Remember me functionality
  final rememberMe = false.obs;

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Select user type (vigile or etudiant)
  void selectUserType(String userType) {
    selectedUserType.value = userType;
  }

  /// Toggle remember me functionality
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Validate form inputs
  bool _validateInputs() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur de Validation',
        'L\'email ne peut pas être vide',
        backgroundColor: const Color(0xFF351F16),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur de Validation',
        'Le mot de passe ne peut pas être vide',
        backgroundColor: const Color(0xFF351F16),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  /// Handle login with automatic user type detection
  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final loginResult = await loginApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      print('Login result: $loginResult');

      // Mise à jour automatique du type d'utilisateur sélectionné
      selectedUserType.value = loginResult['userType'];

      // Navigate based on user type
      if (loginResult['userType'] == 'etudiant') {
        final etudiant = loginResult['user'] as Etudiant;

        Get.snackbar(
          'Connexion Réussie',
          'Bienvenue ${etudiant.nom}!',
          backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
          colorText: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 2),
        );

        // Navigate to student dashboard
        Get.toNamed(Routes.ETUDIANT, arguments: {'etudiantId': etudiant.id});
      } else if (loginResult['userType'] == 'vigile') {
        final vigile = loginResult['user'] as Vigile;

        Get.snackbar(
          'Connexion Réussie',
          'Bienvenue ${vigile.nom}!',
          backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
          colorText: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 2),
        );

        // Navigate to vigile dashboard
        Get.toNamed(Routes.MAIN, arguments: {'initialIndex': 1});
      }
    } catch (e) {
      print('Login failed: $e');
      Get.snackbar(
        'Erreur de Connexion',
        'Email ou mot de passe incorrect',
        backgroundColor: const Color(0xFF351F16),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear form data
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    selectedUserType.value = 'vigile';
    rememberMe.value = false;
  }
}

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
  
  // UI state management
  final rememberMe = false.obs;

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle remember me preference
  void setRememberMe(bool value) {
    rememberMe.value = value;
    
    if (value) {
      print('Remember me enabled');
      // TODO: Implement secure storage for credentials
    } else {
      print('Remember me disabled');
      // TODO: Clear stored credentials
    }
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

    // Basic email validation
  //   if (!GetUtils.isEmail(emailController.text.trim())) {
  //     Get.snackbar(
  //       'Erreur de Validation', 
  //       'Veuillez entrer une adresse email valide',
  //       backgroundColor: const Color(0xFF351F16),
  //       colorText: const Color(0xFFFFFFFF),
  //       duration: const Duration(seconds: 3),
  //     );
  //     return false;
  //   }

    return true;
  }

  /// Handle login - automatically detect user type
  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final loginResult = await loginApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Handle remember me functionality
      if (rememberMe.value) {
        await _saveCredentials();
      }

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
        Get.toNamed(Routes.VIGILE, arguments: {'vigileId': vigile.id});
      }
    } catch (e) {
      print('Login failed: $e');
      Get.snackbar(
        'Erreur de Connexion', 
        'Connexion échouée: ${e.toString()}',
        backgroundColor: const Color(0xFF351F16),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Save credentials for remember me functionality
  Future<void> _saveCredentials() async {
    // TODO: Implement secure storage
    // You might want to use packages like:
    // - flutter_secure_storage
    // - shared_preferences (for non-sensitive data)
    print('Saving credentials for remember me...');
  }

  /// Load saved credentials
  Future<void> _loadSavedCredentials() async {
    // TODO: Implement loading saved credentials
    print('Loading saved credentials...');
  }

  /// Clear form data
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    rememberMe.value = false;
  }

  /// Handle forgot password
  void handleForgotPassword() {
    // TODO: Implement forgot password functionality
    Get.snackbar(
      'Mot de Passe Oublié', 
      'Cette fonctionnalité sera bientôt disponible',
      backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
    );
    
    // You might want to navigate to a forgot password screen
    // Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
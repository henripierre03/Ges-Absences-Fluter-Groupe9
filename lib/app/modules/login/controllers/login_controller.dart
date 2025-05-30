import 'package:flutter/widgets.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
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
  final selectedUserType = 'etudiant'.obs; // Default to student
  final rememberMe = false.obs;
  
  // Data
  final etudiants = <Etudiant>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch students on initialization
    getAllEtudiant();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Set the selected user type (etudiant or vigile)
  void setUserType(String type) {
    selectedUserType.value = type;
    
    // Clear form when switching user types
    emailController.clear();
    passwordController.clear();
    
    // You can add different validation or behavior based on user type
    if (type == 'vigile') {
      // Handle vigile-specific logic if needed
      print('Switched to Vigile mode');
    } else {
      // Handle student-specific logic
      print('Switched to Étudiant mode');
    }
  }

  /// Toggle remember me preference
  void setRememberMe(bool value) {
    rememberMe.value = value;
    
    // You can implement actual remember me functionality here
    // For example, save credentials to secure storage
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
    // if (!GetUtils.isEmail(emailController.text.trim())) {
    //   Get.snackbar(
    //     'Erreur de Validation', 
    //     'Veuillez entrer une adresse email valide',
    //     backgroundColor: const Color(0xFF351F16),
    //     colorText: const Color(0xFFFFFFFF),
    //     duration: const Duration(seconds: 3),
    //   );
    //   return false;
    // }

    return true;
  }

  /// Handle login based on selected user type
  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      if (selectedUserType.value == 'etudiant') {
        await _loginAsStudent();
      } else if (selectedUserType.value == 'vigile') {
        await _loginAsVigile();
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

  /// Login as student
  Future<void> _loginAsStudent() async {
    final etudiant = await loginApiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    // Handle remember me functionality
    if (rememberMe.value) {
      await _saveCredentials();
    }

    Get.snackbar(
      'Connexion Réussie', 
      'Bienvenue ${etudiant.nom}!',
      backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 2),
    );

    // Navigate to student dashboard
    Get.toNamed(Routes.ETUDIANT, arguments: {'etudiantId': etudiant.id});
  }

  /// Login as vigile (security guard)
  Future<void> _loginAsVigile() async {
    // TODO: Implement vigile login logic
    // This would likely call a different API endpoint for vigile authentication
    
    // For now, show a placeholder message
    Get.snackbar(
      'En Développement', 
      'La connexion Vigile sera bientôt disponible',
      backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
    );

    // TODO: Navigate to vigile dashboard when implemented
    // Get.toNamed(Routes.VIGILE_DASHBOARD);
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

  /// Fetch all students
  Future<void> getAllEtudiant() async {
    // Don't show loading for background data fetch
    // unless it's the initial load
    final bool showLoading = etudiants.isEmpty;
    
    if (showLoading) {
      isLoading.value = true;
    }

    try {
      final allEtudiants = await loginApiService.getAllEtudiants();
      etudiants.assignAll(allEtudiants);
      
      print('Successfully loaded ${allEtudiants.length} students');
    } catch (e) {
      print('Failed to fetch students: $e');
      
      // Only show error snackbar if it's a user-initiated action
      if (showLoading) {
        Get.snackbar(
          'Erreur de Chargement', 
          'Impossible de charger la liste des étudiants: ${e.toString()}',
          backgroundColor: const Color(0xFF351F16),
          colorText: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Refresh student list
  Future<void> refreshStudents() async {
    await getAllEtudiant();
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

  /// Get user type display name
  String get userTypeDisplayName {
    switch (selectedUserType.value) {
      case 'etudiant':
        return 'Étudiant';
      case 'vigile':
        return 'Vigile';
      default:
        return 'Utilisateur';
    }
  }

  /// Check if current user type is student
  bool get isStudentMode => selectedUserType.value == 'etudiant';

  /// Check if current user type is vigile
  bool get isVigileMode => selectedUserType.value == 'vigile';
}
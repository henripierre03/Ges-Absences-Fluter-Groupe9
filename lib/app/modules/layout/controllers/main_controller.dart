import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';

class MainController extends GetxController {
  var selectedIndex = 1.obs;
  var isLoggingOut = false.obs;
  var userRole = ''.obs;

  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box('authBox');
    _loadUserRole();
  }

  void changeTab(int index) {
    if (index == 0) {
      _handleLogout();
      return;
    }
    selectedIndex.value = index;
  }

  void _loadUserRole() {
    userRole.value = authBox.get('role', defaultValue: '');
  }

  void _handleLogout() {
    Get.defaultDialog(
      title: 'Déconnexion',
      middleText: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      textConfirm: 'Oui',
      textCancel: 'Non',
      confirmTextColor: Colors.white,
      cancelTextColor: const Color(0xFFFF6B00),
      buttonColor: const Color(0xFFFF6B00),
      barrierDismissible: false,
      onConfirm: () {
        _performLogout();
      },
      onCancel: () {
        print('Déconnexion annulée');
      },
    );
  }

  Future<void> _performLogout() async {
    isLoggingOut.value = true;

    try {
      Get.back();

      // Centraliser la déconnexion via LoginController
      if (Get.isRegistered<LoginController>()) {
        final loginController = Get.find<LoginController>();
        await loginController.logout();
        // Le loginController.logout() effectue nettoyage + redirection
      } else {
        // Au cas où loginController n'est pas enregistré, faire nettoyage manuel
        await _clearUserData();
        Get.offAllNamed(Routes.LOGIN);
      }

      Get.snackbar(
        'Déconnexion',
        'Vous avez été déconnecté avec succès',
        backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors de la déconnexion',
        backgroundColor: const Color(0xFF351F16),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  Future<void> _clearUserData() async {
    try {
      // Suppression des données persistantes
      await authBox.clear();
    } catch (e) {
      print('Erreur lors du nettoyage des données: $e');
    }
  }

  /// Appelable pour forcer une déconnexion sans confirmation
  Future<void> logoutDirect() async {
    await _performLogout();
  }

  // Aller directement à la carte
  void goToMap() {
    selectedIndex.value = 3;
  }

  // Retourner à l'accueil
  void goToHome() {
    selectedIndex.value = 1;
  }
}

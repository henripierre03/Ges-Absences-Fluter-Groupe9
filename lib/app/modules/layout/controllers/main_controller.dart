import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Si vous utilisez SharedPreferences

class MainController extends GetxController {
  var selectedIndex = 1.obs;
  var isLoggingOut = false.obs;

  void changeTab(int index) {
    // Si l'utilisateur clique sur l'icône logout (index 0)
    if (index == 0) {
      _handleLogout();
      return;
    }

    selectedIndex.value = index;
  }

  /// Gérer la déconnexion avec confirmation
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
        // Optionnel : action lors de l'annulation
        print('Déconnexion annulée');
      },
    );
  }

  /// Effectuer la déconnexion avec nettoyage complet
  Future<void> _performLogout() async {
    isLoggingOut.value = true;

    try {
      Get.back();

      await _clearUserData();

      // Supprimer le LoginController si il existe encore
      if (Get.isRegistered<LoginController>()) {
        final loginController = Get.find<LoginController>();
        loginController.clearForm();
      }

      // Afficher un message de déconnexion
      Get.snackbar(
        'Déconnexion',
        'Vous avez été déconnecté avec succès',
        backgroundColor: const Color(0xFFF58613).withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );

      // Attendre un peu pour que l'utilisateur voie le message
      await Future.delayed(const Duration(milliseconds: 500));

      // Naviguer vers la page de connexion et supprimer toutes les pages précédentes
      Get.offAllNamed(Routes.LOGIN);
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

  /// Nettoyer les données utilisateur stockées
  Future<void> _clearUserData() async {
    try {
      // Si vous utilisez SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // ou supprimer des clés spécifiques

      // Si vous avez d'autres données à nettoyer, ajoutez-les ici
      // Exemple : tokens d'authentification, données en cache, etc.
    } catch (e) {
      print('Erreur lors du nettoyage des données: $e');
    }
  }

  /// Déconnexion directe sans confirmation (pour usage programmatique)
  Future<void> logoutDirect() async {
    await _performLogout();
  }
}

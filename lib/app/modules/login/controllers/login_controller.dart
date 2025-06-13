import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/login_api_service.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/data/dto/request/login_request.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginApiServiceSpring loginService = LoginApiServiceSpring();

  var isLoading = false.obs;
  var rememberMe = false.obs;

  late Box authBox;

  @override
  void onInit() {
    super.onInit();
    // Ouvre la box authBox ou récupère la box déjà ouverte
    authBox = Hive.box('authBox');
    // Charger la valeur sauvegardée de rememberMe
    rememberMe.value = authBox.get('rememberMe', defaultValue: false);
  }

  Future<void> login() async {
    isLoading.value = true;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs");
      isLoading.value = false;
      return;
    }

    try {
      final loginRequest = LoginRequest(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final data = await loginService.login(loginRequest);

      if (data['token'] != null) {
        await authBox.put('token', data['token']);
        await authBox.put('role', data['role']);
        await authBox.put('rememberMe', rememberMe.value);
        String role = data['role'];
        if (role == 'ETUDIANT' && data['matricule'] != null) {
          await authBox.put('matricule', data['matricule'].toString());
        }
        await authBox.put('userId', data['id']);
        print("User ID saved in Hive: ${data['id']}");

        Get.snackbar("Succès", "Connecté en tant que $role");
        redirectUserByRole(role);
      } else {
        Get.snackbar(
          "Erreur",
          "Données de connexion invalides",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      Get.snackbar(
        "Erreur de connexion",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Centralise la déconnexion et nettoyage des données
  Future<void> logout() async {
    final token = authBox.get('token');

    try {
      if (token != null) {
        await loginService.logout(token);
      }

      await authBox.clear();

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      await authBox.clear();
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    authBox.put('rememberMe', rememberMe.value);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void redirectUserByRole(String role) {
    switch (role) {
      case 'ETUDIANT':
        Get.offAllNamed(Routes.ETUDIANT);
        break;
      case 'VIGILE':
        Get.offAllNamed(Routes.VIGILE);
        break;
      default:
        Get.snackbar("Erreur", "Rôle inconnu ou non autorisé");
        Get.offAllNamed(Routes.LOGIN);
    }
  }
}

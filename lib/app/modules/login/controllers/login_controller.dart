import 'package:flutter/widgets.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final ILoginApiService loginApiService = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final etudiants = <Etudiant>[].obs; // Assuming Etudiant is your model class

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty');
      return;
    }

    isLoading.value = true;

    try {
      final etudiant = await loginApiService.login(
        emailController.text,
        passwordController.text,
      );

      // Navigate to the EtudiantView with the student ID
      Get.toNamed(Routes.ETUDIANT, arguments: {'etudiantId': etudiant.id});
    } catch (e) {
      print('Login failed: $e');
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllEtudiant() async {
    isLoading.value = true;
    try {
      final allEtudiants = await loginApiService.getAllEtudiants(); // Assuming this method exists in your service
      etudiants.assignAll(allEtudiants);
    } catch (e) {
      print('Failed to fetch students: $e');
      Get.snackbar('Error', 'Failed to fetch students: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

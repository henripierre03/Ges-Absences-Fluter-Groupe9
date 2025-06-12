import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Succès',
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Erreur',
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 4),
  );
}

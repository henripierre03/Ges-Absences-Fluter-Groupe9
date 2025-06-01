import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomeView is working', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.ETUDIANT); // ✅ Bonne pratique
              },
              child: const Text('Aller à la page Étudiant'),
            ),
          ],
        ),
      ),
    );
  }
}

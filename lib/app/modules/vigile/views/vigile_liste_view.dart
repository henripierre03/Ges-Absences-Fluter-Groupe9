import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_liste_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_empty.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_error.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_loading.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/header.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/student_card.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/greeting_app_bar.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/custom_bottom_navigation_bar.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

class VigileListView extends GetView<VigileListController> {
  const VigileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const GreetingAppBar(title: 'Étudiants'),
      body: Column(
        children: [
          const VigileHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const EtatLoading();
              if (controller.hasError.value) return EtatError(controller);
              if (controller.pointagesList.isEmpty) return const EtatEmpty();
              return RefreshIndicator(
                onRefresh: () => controller.refreshPointages(),
                color: const Color(0xFFFF6B00),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ), // Padding bottom pour la bottom nav
                  itemCount: controller.pointagesList.length,
                  itemBuilder: (context, index) {
                    final pointage = controller.pointagesList[index];
                    return StudentCard(
                      pointage: pointage,
                      controller: controller,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Index pour la liste des étudiants
        onTap: (index) {
          // Gérer la navigation selon l'index
          switch (index) {
            case 0:
              // Navigation vers Paramètres ou déconnexion
              _handleLogout();
              break;
            case 1:
              // Navigation vers l'accueil
              Get.offAllNamed(Routes.VIGILE);
              break;
            case 2:
              // Déjà sur la liste des étudiants, ne rien faire
              break;
          }
        },
      ),
    );
  }

  // Méthode pour gérer la déconnexion
  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              // Ajouter ici la logique de déconnexion
              // controller.logout();
              Get.offAllNamed('/login'); // Ajustez selon votre routing
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

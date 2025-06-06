import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/greeting_app_bar.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/qr_scanner_page.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/snackbar_utils.dart';

import 'package:frontend_gesabsence/app/modules/vigile/widgets/custom_navigation_bar.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/vigile_controller.dart';

class VigileView extends GetView<VigileController> {
  final LoginController loginController = Get.find<LoginController>();

  VigileView({super.key});

  final RxInt _selectedIndex = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GreetingAppBar(title: 'Accueil'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'Scan QR Code de l\'étudiant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => _openQRScanner(context),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Color(0xFFF58613),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 30,
                            right: 30,
                            top: 120,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.lightBlueAccent.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Coins du cadre
                          const Positioned(
                            top: 40,
                            left: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            top: 40,
                            right: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            bottom: 40,
                            left: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            bottom: 40,
                            right: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'The QR Code will be automatically detected\nwhen you position it between the guide lines',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Section Recherche
              const Text(
                'Rechercher',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Container orange pour la recherche
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF58613),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Champ de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Veuillez entrer le matricule de l\'étudiant',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        onSubmitted: (value) => _validateSearch(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Bouton Valider avec état de chargement
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: controller.isSearching.value
                              ? null
                              : () => _validateSearch(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isSearching.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Valider',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 100,
              ), // Espace supplémentaire pour la bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex.value,
        onTap: (index) async {
          if (index == 0) {
            // déconnexion
            final shouldLogout = await Get.dialog<bool>(
              AlertDialog(
                title: const Text('Déconnexion'),
                content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Déconnecter'),
                  ),
                ],
              ),
              barrierDismissible: false,
            );

            if (shouldLogout == true) {
              await loginController.logout();
            }
          } else if (index == 2) {
            // aller vers la liste
            Get.offAllNamed(Routes.LISTE_VIGILE);
          } else {
            _selectedIndex.value = index;
          }
        },
      ),
    );
  }

  // Méthode pour ouvrir le scanner QR
  void _openQRScanner(BuildContext context) async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerPage()),
      );

      if (result != null && result is String) {
        controller.handleQRScan(result);
      }
    } else {
      showErrorSnackbar('Permission caméra refusée');
    }
  }

  // Méthode pour valider la recherche
  void _validateSearch() {
    final searchText = controller.searchController.text.trim();
    if (searchText.isNotEmpty) {
      controller.searchStudentByMatricule(searchText);
    } else {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer un matricule',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

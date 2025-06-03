import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';

class EtudiantView extends GetView<EtudiantController> {
  EtudiantView({super.key});

  // Rx pour l'index de la page sélectionnée dans le BottomNavigationBar
  final RxInt _selectedIndex = 0.obs;

  // Récupérer LoginController pour la déconnexion
  final LoginController loginController = Get.find<LoginController>();

  // Pages correspondantes aux onglets
  final List<Widget> _pages = [
    Center(child: Text('Accueil')),
    Center(child: Text('Absences')),
    Center(child: Text('Profil')),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Bienvenue, Étudiant'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Déconnexion',
              onPressed: () async {
                // Confirmer la déconnexion
                final shouldLogout = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text('Déconnexion'),
                    content: Text('Voulez-vous vraiment vous déconnecter ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text('Déconnecter'),
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );

                if (shouldLogout == true) {
                  await loginController.logout();
                }
              },
            ),
          ],
        ),
        body: _pages[_selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_busy),
              label: 'Absences',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

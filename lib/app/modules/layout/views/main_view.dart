import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/views/etudiant_view.dart';
import 'package:frontend_gesabsence/app/modules/home/views/home_view.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [HomeView(), HomeView(), EtudiantView()];

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            ['Logout', 'Accueil', 'Étudiants'][controller.selectedIndex.value],
          ),
        ),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Étudiants'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'Liste des étudiants',
            ),
          ],
        ),
      ),
    );
  }
}

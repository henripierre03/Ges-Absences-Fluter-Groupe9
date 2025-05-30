import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/views/etudiant_view.dart';
import 'package:frontend_gesabsence/app/modules/home/views/home_view.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:frontend_gesabsence/app/modules/parametres/views/parametres_view.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  List<Widget> get pages => [ParametresView(), HomeView(), EtudiantView()];

  final List<String> titles = ['Paramètres', 'Accueil', 'Étudiants'];

  final List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_rounded),
      label: 'Étudiants',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(titles[controller.selectedIndex.value])),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          items: bottomNavItems,
        ),
      ),
    );
  }
}

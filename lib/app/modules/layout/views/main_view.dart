import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/layout/controllers/main_controller.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/custom_bottom_navigation_bar.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/greeting_app_bar.dart';
import 'package:frontend_gesabsence/app/modules/parametres/views/parametres_view.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/vigile_liste_view.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/vigile_view.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final List<Widget> pages = [ParametresView(), VigileView(), VigileListView()];
  final List<String> titles = ['Paramètres', 'Accueil', 'Étudiants'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: GreetingAppBar(title: titles[controller.selectedIndex.value]),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}

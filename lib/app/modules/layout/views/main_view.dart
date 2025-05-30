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

  // Fonction pour obtenir le salut selon l'heure
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 17) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_getGreeting()}, ',
                        style: const TextStyle(
                          color: Color(0xFFFF6B00),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: 'Chère Vigile',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black87,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF6B00),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/avatar.png', // Remplacez par le chemin de votre image
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Widget de fallback si l'image n'est pas trouvée
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.logout,
            isSelected: currentIndex == 0,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.home_filled,
            isSelected: currentIndex == 1,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.list_alt_sharp,
            isSelected: currentIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    // Inverser l'icône de logout
    IconData displayIcon = icon;
    if (icon == Icons.logout) {
      displayIcon = Icons.login;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedScale(
          scale: isSelected ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.25 : 0.15),
                  blurRadius: isSelected ? 15 : 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFFFF6B00)
                    : const Color(0xFFFF8C00),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  displayIcon,
                  key: ValueKey('$index-$isSelected'),
                  color: isSelected ? Colors.white : Colors.black87,
                  size: isSelected ? 34 : 32,
                  weight: 600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

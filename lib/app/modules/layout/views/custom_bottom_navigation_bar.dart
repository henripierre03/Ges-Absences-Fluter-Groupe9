import 'package:flutter/material.dart';

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
          _NavItem(
            index: 0,
            icon: Icons.logout,
            isSelected: currentIndex == 0,
            onTap: onTap,
            isLogout: true,
          ),
          _NavItem(
            index: 1,
            icon: Icons.home_filled,
            isSelected: currentIndex == 1,
            onTap: onTap,
          ),
          _NavItem(
            index: 2,
            icon: Icons.person_rounded,
            isSelected: currentIndex == 2,
            onTap: onTap,
          ),
          _NavItem(
            index: 3,
            icon: Icons.map,
            isSelected: currentIndex == 3,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final bool isSelected;
  final Function(int) onTap;
  final bool isLogout;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    // Pour l'icône de déconnexion, on garde toujours logout
    IconData displayIcon = isLogout ? Icons.logout : icon;

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
                color: isLogout && isSelected
                    ? const Color(0xFFDC3545)
                    : isSelected
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

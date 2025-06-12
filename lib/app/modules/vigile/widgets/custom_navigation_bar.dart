// Custom Bottom Navigation Bar
import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/nav_item.dart';

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
          NavItem(
            index: 0,
            icon: Icons.logout,
            isSelected: currentIndex == 0,
            onTap: onTap,
            isLogout: true,
          ),
          NavItem(
            index: 1,
            icon: Icons.home_filled,
            isSelected: currentIndex == 1,
            onTap: onTap,
          ),
          NavItem(
            index: 2,
            icon: Icons.list_alt_sharp,
            isSelected: currentIndex == 2,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

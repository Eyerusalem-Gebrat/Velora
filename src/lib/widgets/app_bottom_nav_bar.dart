import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> _unselectedIcons = [
    Icons.home_outlined,
    Icons.search_rounded,
    Icons.shopping_bag_outlined,
    Icons.person_outline,
  ];

  static const List<IconData> _selectedIcons = [
    Icons.home,
    Icons.search_rounded,
    Icons.shopping_bag,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.navBarBackground,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              final isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.25)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected ? _selectedIcons[index] : _unselectedIcons[index],
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                    size: 22,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

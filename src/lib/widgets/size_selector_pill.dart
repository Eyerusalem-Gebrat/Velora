import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SizeSelectorPill extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback? onTap;

  const SizeSelectorPill({
    super.key,
    required this.size,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.toggleInactiveBg,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? null
              : const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

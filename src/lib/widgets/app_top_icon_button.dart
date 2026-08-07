import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badgeCount;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const AppTopIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badgeCount,
    this.backgroundColor = AppColors.cardWhite,
    this.iconColor = AppColors.textPrimary,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: backgroundColor == Colors.transparent
                  ? null
                  : const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.48,
            ),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.badgeRed,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

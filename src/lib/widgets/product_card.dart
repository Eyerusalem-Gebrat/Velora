import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../utils/format_helpers.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container filling ~70%
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: product.imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.iconButtonBg,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.iconButtonBg,
                                child: const Icon(
                                  Icons.checkroom_outlined,
                                  color: AppColors.textSecondary,
                                  size: 32,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.iconButtonBg,
                              child: const Icon(
                                Icons.checkroom_outlined,
                                size: 36,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                  ),
                  // Optional badge top-left
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                formatPrice(product.price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.price,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

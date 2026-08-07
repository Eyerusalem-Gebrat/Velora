import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/size_selector_pill.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({
    super.key,
    this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSizeIndex = 2; // 'M' is selected by default

  final List<String> _sizes = const ['XS', 'S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.product?.title ?? 'Oversized Knitted Dress';
    final displayPrice = widget.product?.price ?? 700.00;
    const double originalPrice = 950.00;
    final imageUrl = widget.product?.imageUrl ?? 'https://picsum.photos/seed/detail/400/600';

    final mediaQuery = MediaQuery.of(context);
    final imageHeight = mediaQuery.size.height * 0.52;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable area
          SingleChildScrollView(
            child: Column(
              children: [
                // Product Image Container with Floating Actions & Dots
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Large Image filling top with rounded bottom corners
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: AppColors.iconButtonBg),
                          ),
                        ),
                      ),

                      // Floating Header Bar
                      Positioned(
                        top: mediaQuery.padding.top + 8,
                        left: 20,
                        right: 20,
                        child: Row(
                          children: [
                            AppTopIconButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            AppTopIconButton(
                              icon: Icons.shopping_bag_outlined,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CartScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Vertical indicator dots on right edge
                      Positioned(
                        right: 16,
                        top: imageHeight * 0.45,
                        child: Column(
                          children: [
                            Container(
                              width: 6,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Card overlapping image slightly
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // New Season & Rating row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'New Season',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star_border_rounded,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8 (120 reviews)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Title and Price row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  displayTitle,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${originalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${displayPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.price,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Size selector pills
                          Row(
                            children: List.generate(_sizes.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizeSelectorPill(
                                  size: _sizes[index],
                                  isSelected: _selectedSizeIndex == index,
                                  onTap: () => setState(
                                      () => _selectedSizeIndex = index),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 20),

                          // Description section
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4,
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "Check out this comfy oversized knitted dress from Porsche's racing heritage! It's made with care, has some cool functional details, and a sleek look—perfect for anyone who loves style and performance ",
                                ),
                                TextSpan(
                                  text: 'Read More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 80), // bottom space for fixed bar
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom fixed action bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 24,
                top: 12,
              ),
              child: Row(
                children: [
                  // Women category pill button
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppColors.toggleInactiveBg,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Women',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to Bag pill button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Add to Bag',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_pill.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryName;

  const ProductListScreen({
    super.key,
    this.categoryName = 'Dresses',
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedFilterIndex = 0;
  int _navIndex = 1;

  final List<String> _filters = const ['All', 'Dresses', 'Tops', 'Shoes'];

  final List<Product> _products = const [
    Product(
      id: 1,
      title: 'Knitted Sweater',
      price: 49.00,
      description: 'Cozy knitted sweater',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/201/300/400',
      badge: 'New in',
    ),
    Product(
      id: 2,
      title: 'Oversized Blazer',
      price: 89.00,
      description: 'Classic oversized blazer',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/202/300/400',
      badge: 'Best Seller',
    ),
    Product(
      id: 3,
      title: 'Slip Midi Dress',
      price: 65.00,
      description: 'Elegant slip midi dress',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/203/300/400',
      badge: 'New in',
    ),
    Product(
      id: 4,
      title: 'Relaxed Shirt',
      price: 39.00,
      description: 'Casual relaxed shirt',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/204/300/400',
    ),
  ];

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _handleNavTap(int index) {
    if (index == 1) return; // already on search / list
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // 1. Top row: back button, category title, bag icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      AppTopIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.categoryName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      AppTopIconButton(
                        icon: Icons.shopping_bag_outlined,
                        badgeCount: 2,
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

                const SizedBox(height: 16),

                // 2. Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppSearchBar(
                    onFilterTap: () {},
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Filter pills row
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterPill(
                          label: _filters[index],
                          isSelected: _selectedFilterIndex == index,
                          onTap: () =>
                              setState(() => _selectedFilterIndex = index),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Scrollable GridView of products
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 90,
                    ),
                    itemCount: _products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentIndex: _navIndex,
              onTap: (index) {
                setState(() => _navIndex = index);
                _handleNavTap(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

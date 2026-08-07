import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/product_card.dart';
import '../widgets/category_icon_item.dart';
import 'product_list_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final List<Product> _trendingProducts = const [
    Product(
      id: 1,
      title: 'Knitted Sweater',
      price: 49.00,
      description: 'Cozy knitted sweater',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/101/300/400',
      badge: 'New in',
    ),
    Product(
      id: 2,
      title: 'Oversized Blazer',
      price: 89.00,
      description: 'Classic oversized blazer',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/102/300/400',
      badge: 'Best Seller',
    ),
    Product(
      id: 3,
      title: 'Slip Midi Dress',
      price: 65.00,
      description: 'Elegant slip midi dress',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/103/300/400',
      badge: 'New in',
    ),
    Product(
      id: 4,
      title: 'Relaxed Shirt',
      price: 39.00,
      description: 'Casual relaxed shirt',
      category: "women's clothing",
      image: 'https://picsum.photos/seed/104/300/400',
    ),
  ];

  void _navigateToProductList([String? category]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(categoryName: category ?? 'Dresses'),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _handleNavTap(int index) {
    if (index == 0) return;
    if (index == 1) {
      _navigateToProductList();
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // 1. Top row: "Velora" wordmark on left, bag button on right
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Velora',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: AppColors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
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

                  const SizedBox(height: 24),

                  // 2. Category section header & horizontal row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _navigateToProductList(),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 86,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: CategoryIconItem(
                            icon: Icons.checkroom_outlined,
                            label: 'Dresses',
                            isSelected: true,
                            onTap: () => _navigateToProductList('Dresses'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: CategoryIconItem(
                            icon: Icons.dry_cleaning_outlined,
                            label: 'Tops',
                            onTap: () => _navigateToProductList('Tops'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: CategoryIconItem(
                            icon: Icons.roller_skating_outlined,
                            label: 'Shoes',
                            onTap: () => _navigateToProductList('Shoes'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: CategoryIconItem(
                            icon: Icons.brush_outlined,
                            label: 'Beauty',
                            onTap: () => _navigateToProductList('Beauty'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: CategoryIconItem(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Accessories',
                            onTap: () => _navigateToProductList('Accessories'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Trending Now header & 2-column GridView
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trending Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _navigateToProductList(),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _trendingProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final product = _trendingProducts[index];
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
          ),

          // Fixed bottom navigation bar
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

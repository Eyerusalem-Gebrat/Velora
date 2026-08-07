import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/product_card.dart';
import '../widgets/category_icon_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<ProductProvider>().fetchCategories();
    });
  }

  void _navigateToProductList([String? category]) {
    if (category != null) {
      context.read<ProductProvider>().setSelectedCategory(category);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          categoryName: category != null ? _formatCategoryLabel(category) : 'All Products',
        ),
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

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('electronics')) {
      return Icons.devices_other_outlined;
    } else if (lower.contains('jewelery') || lower.contains('jewelry')) {
      return Icons.diamond_outlined;
    } else if (lower.contains('men')) {
      return Icons.male_outlined;
    } else if (lower.contains('women')) {
      return Icons.female_outlined;
    }
    return Icons.grid_view_outlined;
  }

  String _formatCategoryLabel(String rawCategory) {
    if (rawCategory.isEmpty) return rawCategory;
    final words = rawCategory.split(' ');
    return words.map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }

  Widget _buildBody(ProductProvider productProvider) {
    if (productProvider.isLoading && productProvider.allProducts.isEmpty) {
      return const LoadingWidget();
    }

    if (productProvider.errorMessage != null && productProvider.allProducts.isEmpty) {
      return ErrorStateWidget(
        message: productProvider.errorMessage!,
        onRetry: () {
          context.read<ProductProvider>().fetchProducts();
          context.read<ProductProvider>().fetchCategories();
        },
      );
    }

    final trendingProducts = productProvider.allProducts.take(6).toList();
    final selectedCat = productProvider.selectedCategory;

    return SingleChildScrollView(
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
                  badgeCount: context.watch<CartProvider>().itemCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Search bar -> tapping navigates to search page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => _navigateToProductList(),
              child: const AbsorbPointer(
                child: AppSearchBar(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Category section header & horizontal list from API categories
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: productProvider.categories.length,
              itemBuilder: (context, index) {
                final category = productProvider.categories[index];
                final isSelected = selectedCat == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: CategoryIconItem(
                    icon: _getCategoryIcon(category),
                    label: _formatCategoryLabel(category),
                    isSelected: isSelected,
                    onTap: () => _navigateToProductList(category),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 4. Trending Now header & 2-column GridView
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
              itemCount: trendingProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final product = trendingProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: _buildBody(productProvider),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/format_helpers.dart';
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
          categoryName: category != null ? formatCategory(category) : 'All Products',
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

  // Short display name for each API category string.
  String _categoryLabel(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('women')) return 'Women';
    if (lower.contains('men')) return 'Men';
    if (lower.contains('electronics')) return 'Electronics';
    if (lower.contains('jewelery') || lower.contains('jewelry')) return 'Jewelry';
    return formatCategory(category);
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('electronics')) {
      return Icons.devices_other_outlined;
    } else if (lower.contains('jewelery') || lower.contains('jewelry')) {
      return Icons.diamond_outlined;
    } else if (lower.contains('women')) {
      return Icons.female;
    } else if (lower.contains('men')) {
      return Icons.male;
    }
    return Icons.grid_view_outlined;
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

    final products = productProvider.allProducts;
    final selectedCat = productProvider.selectedCategory;
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    }

    final childAspectRatio = screenWidth >= 600 ? 0.76 : 0.72;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
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

          const SizedBox(height: 24),

          // 2. Category section header (no "See all") & evenly spaced row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: productProvider.categories.map((category) {
                final isSelected = selectedCat == category;
                return Expanded(
                  child: Center(
                    child: CategoryIconItem(
                      icon: _getCategoryIcon(category),
                      label: _categoryLabel(category),
                      isSelected: isSelected,
                      onTap: () => _navigateToProductList(category),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Products header "All Products" (no "See all") & responsive GridView
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
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

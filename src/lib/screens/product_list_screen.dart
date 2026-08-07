import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_pill.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryName;

  const ProductListScreen({
    super.key,
    this.categoryName,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _navIndex = 1;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final query = context.read<ProductProvider>().searchQuery;
    _searchController = TextEditingController(text: query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  String _formatCategoryTitle(String? selectedCategory) {
    if (selectedCategory == null ||
        selectedCategory.isEmpty ||
        selectedCategory == 'All') {
      return 'All Products';
    }
    final words = selectedCategory.split(' ');
    return words.map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }

  Widget _buildProductGrid(ProductProvider productProvider) {
    if (productProvider.isLoading && productProvider.allProducts.isEmpty) {
      return const LoadingWidget();
    }

    if (productProvider.errorMessage != null &&
        productProvider.allProducts.isEmpty) {
      return ErrorStateWidget(
        message: productProvider.errorMessage!,
        onRetry: () {
          context.read<ProductProvider>().fetchProducts();
          context.read<ProductProvider>().fetchCategories();
        },
      );
    }

    final filteredProducts = productProvider.filteredProducts;

    if (filteredProducts.isEmpty) {
      return const EmptyStateWidget(
        message: 'No products found',
      );
    }

    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 90,
      ),
      itemCount: filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(
          product: product,
          onTap: () => _navigateToProductDetail(product),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final selectedCategory = productProvider.selectedCategory;
    final titleText = _formatCategoryTitle(selectedCategory);
    final filterPills = ['All', ...productProvider.categories];

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
                          titleText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      AppTopIconButton(
                        icon: Icons.shopping_bag_outlined,
                        // TODO: wire to CartProvider.itemCount in the cart commit
                        badgeCount: 0,
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
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<ProductProvider>().setSearchQuery(value);
                    },
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
                    itemCount: filterPills.length,
                    itemBuilder: (context, index) {
                      final cat = filterPills[index];
                      final isSelected = (cat == 'All')
                          ? (selectedCategory == null || selectedCategory == 'All')
                          : (selectedCategory == cat);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterPill(
                          label: _formatCategoryTitle(cat),
                          isSelected: isSelected,
                          onTap: () {
                            if (cat == 'All') {
                              context
                                  .read<ProductProvider>()
                                  .setSelectedCategory(null);
                            } else {
                              context
                                  .read<ProductProvider>()
                                  .setSelectedCategory(cat);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Scrollable GridView / State handling
                Expanded(
                  child: _buildProductGrid(productProvider),
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

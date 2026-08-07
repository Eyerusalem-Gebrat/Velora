import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../widgets/app_top_icon_button.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Started empty by default as requested.
  // Set to _sampleCartItems to view populated state during development.
  List<CartItem> _cartItems = [];

  static final List<CartItem> _sampleCartItems = [
    CartItem(
      product: const Product(
        id: 1,
        title: 'Knitted Sweater',
        price: 49.00,
        description: 'Cozy knitted sweater',
        category: "women's clothing",
        image: 'https://picsum.photos/seed/201/300/400',
      ),
      originalPrice: 65.00,
      size: 'S',
      color: 'White',
      quantity: 1,
    ),
    CartItem(
      product: const Product(
        id: 2,
        title: 'Oversized Blazer',
        price: 89.00,
        description: 'Classic oversized blazer',
        category: "women's clothing",
        image: 'https://picsum.photos/seed/202/300/400',
      ),
      size: 'M',
      color: 'Grey',
      quantity: 2,
    ),
    CartItem(
      product: const Product(
        id: 3,
        title: 'Slip Midi Dress',
        price: 65.00,
        description: 'Elegant slip midi dress',
        category: "women's clothing",
        image: 'https://picsum.photos/seed/203/300/400',
      ),
      size: 'L',
      color: 'Black',
      quantity: 1,
    ),
  ];

  double get _subtotal {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _loadSampleItems() {
    setState(() {
      _cartItems = List.from(_sampleCartItems);
    });
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _handleNavTap(int index) {
    if (index == 2) return; // already on cart
    if (index == 0) {
      _navigateToHome();
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
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
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTopIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: _navigateToHome,
                      ),
                      const Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppTopIconButton(
                        icon: Icons.grid_view_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Main Content
                Expanded(
                  child: _cartItems.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const EmptyStateWidget(
                              icon: Icons.shopping_bag_outlined,
                              message: 'Your cart is empty',
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _loadSampleItems,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(Icons.add_shopping_cart, size: 16),
                              label: const Text('Add Demo Items'),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 160,
                          ),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            final isFirstItemTrash = index == 0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
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
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Product Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 76,
                                      height: 76,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        width: 76,
                                        height: 76,
                                        color: AppColors.iconButtonBg,
                                        child: const Icon(
                                          Icons.checkroom_outlined,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Details Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Size: ${item.size}  •  Color: ${item.color}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            if (item.originalPrice != null) ...[
                                              Text(
                                                '\$${item.originalPrice!.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textSecondary,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                            Text(
                                              '\$${item.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.price,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action (Trash icon or Stepper)
                                  if (isFirstItemTrash)
                                    GestureDetector(
                                      onTap: () => _removeItem(index),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.badgeRed
                                              .withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.badgeRed,
                                          size: 18,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.iconButtonBg,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                _decrementQuantity(index),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Icon(
                                                Icons.remove,
                                                size: 14,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                _incrementQuantity(index),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              child: Icon(
                                                Icons.add,
                                                size: 14,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // Bottom Summary & Checkout Bar (visible only when cart is not empty)
          if (_cartItems.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 90,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '\$${_subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.price,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              cartItems: _cartItems,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),

          // Fixed Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentIndex: 2,
              onTap: _handleNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

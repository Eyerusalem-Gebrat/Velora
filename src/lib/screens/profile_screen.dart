import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';
import 'home_screen.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.toggleInactiveBg),
      ],
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 3) return; // already on profile
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title
                const Center(
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Main body state management
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (authProvider.isUserLoading && currentUser == null) {
                        return const LoadingWidget();
                      }

                      if (authProvider.userErrorMessage != null &&
                          currentUser == null) {
                        return ErrorStateWidget(
                          message: authProvider.userErrorMessage!,
                          onRetry: () {
                            final username =
                                authProvider.loggedInUsername ?? 'mor_2314';
                            context
                                .read<AuthProvider>()
                                .fetchCurrentUser(username);
                          },
                        );
                      }

                      // User data loaded
                      final name = currentUser?.fullName ?? 'User Profile';
                      final email = currentUser?.email ?? '';
                      final phone = currentUser?.phone ?? '';
                      final address = currentUser?.fullAddress ?? '';

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 110,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar & Name Header
                            Row(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: const BoxDecoration(
                                    color: AppColors.bannerBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 38,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(
                                  color: AppColors.toggleInactiveBg),
                            ),

                            // Personal Information Section Header
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Info Card
                            Container(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    icon: Icons.person_outline_rounded,
                                    label: 'Full Name',
                                    value: name,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.mail_outline_rounded,
                                    label: 'Email',
                                    value: email,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone Number',
                                    value: phone,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: 'Address',
                                    value: address,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.calendar_today_outlined,
                                    label: 'Joined',
                                    value: 'March 12, 2024',
                                    showDivider: false,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Account Section
                            const Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await context
                                          .read<AuthProvider>()
                                          .logout();
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LoginScreen()),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.logout_rounded,
                                            color: AppColors.textPrimary,
                                            size: 20,
                                          ),
                                          SizedBox(width: 14),
                                          Text(
                                            'Log Out',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: AppColors.textSecondary,
                                            size: 20,
                                          ),
                                        ],
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

          // Fixed Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentIndex: 3,
              onTap: (index) => _handleNavTap(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

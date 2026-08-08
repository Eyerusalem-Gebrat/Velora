import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // To read the storage or do async work before run app
  WidgetsFlutterBinding.ensureInitialized();

  // Load persistent data before the first frame renders.
  final authProvider = AuthProvider();
  final cartProvider = CartProvider();
  await Future.wait([
    authProvider.checkExistingSession(),
    cartProvider.loadCart(),
  ]);

  runApp(VeloraApp(
    authProvider: authProvider,
    cartProvider: cartProvider,
  ));
}

class VeloraApp extends StatelessWidget {
  final AuthProvider authProvider;
  final CartProvider cartProvider;

  const VeloraApp({
    super.key,
    required this.authProvider,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider.value(value: cartProvider),
      ],
      child: MaterialApp(
        title: 'Velora',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RootScreen(),
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Rebuild again if isloggedin changed
    final isLoggedIn =
        context.select<AuthProvider, bool>((auth) => auth.isLoggedIn);
    if (isLoggedIn) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}

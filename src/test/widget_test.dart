import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:src/main.dart';
import 'package:src/providers/auth_provider.dart';
import 'package:src/providers/cart_provider.dart';

void main() {
  testWidgets('Velora app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(VeloraApp(
      authProvider: AuthProvider(),
      cartProvider: CartProvider(),
    ));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

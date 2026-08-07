import 'package:flutter_test/flutter_test.dart';
import 'package:src/main.dart';

void main() {
  testWidgets('Velora app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VeloraApp());
    expect(find.text('Velora'), findsWidgets);
  });
}

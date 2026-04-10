import 'package:flutter_test/flutter_test.dart';
import 'package:cat_girl_calculator/app.dart';

void main() {
  testWidgets('App can be instantiated', (WidgetTester tester) async {
    await tester.pumpWidget(const CatGirlCalculatorApp());
    // Verify the app builds without errors
    expect(find.byType(CatGirlCalculatorApp), findsOneWidget);
  });
}

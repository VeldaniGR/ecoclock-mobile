import 'package:flutter_test/flutter_test.dart';
import 'package:ecoclock_mobile/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoClockApp());
    expect(find.text('Eco\'clock Network'), findsOneWidget);
  });
}

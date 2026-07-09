import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_2/main.dart';

void main() {
  testWidgets('Assignment app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('CSE 489 Assignment'), findsOneWidget);
    expect(find.text('Select an option from the drawer.'), findsOneWidget);
  });
}

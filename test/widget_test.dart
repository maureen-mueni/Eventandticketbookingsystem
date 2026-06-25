import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EventifyApp());
    expect(find.text('Eventify'), findsWidgets);
  });
}

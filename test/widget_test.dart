// This is a basic Flutter widget test for the Alarm Clock App.

import 'package:flutter_test/flutter_test.dart';
import 'package:alarm_clock_app/main.dart';

void main() {
  testWidgets('Alarm Clock App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlarmClockApp());

    // Verify that the app title is displayed.
    expect(find.text('Alarm Clock'), findsOneWidget);
  });
}

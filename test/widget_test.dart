import 'package:flutter_test/flutter_test.dart';
import 'package:untitled2/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This test might need adjustment because Hive requires initialization
    // which is usually mocked in unit tests.
    await tester.pumpWidget(const TimetableApp());

    // Verify that the Welcome screen text is present.
    expect(find.text('Timetable Generator'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:flow_dots/main.dart';

void main() {
  testWidgets('FlowDots app loads and shows Home screen', (WidgetTester tester) async {

    // Load app
    await tester.pumpWidget(const FlowDotsApp());

    // Wait for splash screen to finish
    await tester.pumpAndSettle();

    // Check if Home Screen UI appears
    expect(find.text('FlowDots'), findsWidgets);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Daily Challenge'), findsOneWidget);
    expect(find.text('Sound'), findsOneWidget);
    expect(find.text('Time Trial'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
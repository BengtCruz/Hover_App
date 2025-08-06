import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hover_app/main.dart';

void main() {
  testWidgets('App should load and show home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HoverApp());

    // Verify that the app loads with expected title
    expect(find.text('Loading map...'), findsOneWidget);
    
    // Verify bottom navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify navigation items exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

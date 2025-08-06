// This is a basic Flutter widget test for the Hover ride-hailing app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hover_app/main.dart';

void main() {
  testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HoverApp());

    // Verify that the app name appears on splash screen
    expect(find.text('Hover'), findsOneWidget);
    expect(find.text('Your ride, your way'), findsOneWidget);
    
    // Verify the taxi icon is present
    expect(find.byIcon(Icons.local_taxi), findsOneWidget);
  });

  testWidgets('Navigation flows correctly from splash to welcome', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HoverApp());

    // Wait for splash screen navigation timer
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Should navigate to welcome page
    expect(find.text('Welcome to Hover'), findsOneWidget);
  });
}

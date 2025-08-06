// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hover_app/main.dart';

void main() {
  testWidgets('Location detection UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our initial message is displayed.
    expect(find.text('Press the button to get your current location'), findsOneWidget);
    expect(find.text('Your Current Location:'), findsOneWidget);

    // Verify the location icon is present
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    
    // Verify the floating action button with location icon is present
    expect(find.byIcon(Icons.my_location), findsOneWidget);
    
    // Tap the location button and trigger a frame.
    await tester.tap(find.byIcon(Icons.my_location));
    await tester.pump();

    // Verify that the loading state is shown
    expect(find.text('Getting location...'), findsOneWidget);
  });
}

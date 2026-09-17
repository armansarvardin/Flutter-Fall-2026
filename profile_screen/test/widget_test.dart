// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile_screen/main.dart';
import 'package:profile_screen/data.dart';

void main() {
  testWidgets('shows profile data', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text(myName), findsOneWidget);
    expect(find.text(myUniversity), findsOneWidget);
    for (final fact in facts) {
      expect(find.text(fact.label), findsOneWidget);
      expect(find.text(fact.value), findsOneWidget);
    }
  });
}

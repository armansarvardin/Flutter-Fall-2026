import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practice_5/contacts.dart';
import 'package:practice_5/main.dart';

void main() {
  testWidgets('contact list scrolls through all contacts', (tester) async {
    await tester.pumpWidget(const MyApp());

    final list = tester.widget<ListView>(find.byType(ListView));
    final delegate = list.childrenDelegate as SliverChildBuilderDelegate;
    expect(delegate.childCount, contacts.length * 2 - 1);
    expect(find.text('20 contacts'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -4000));
    await tester.pumpAndSettle();
    expect(find.text(contacts.last.name), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 4000));
    await tester.pumpAndSettle();
    expect(find.text(contacts.first.name), findsOneWidget);
  });
}

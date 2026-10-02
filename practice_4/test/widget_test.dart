import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practice_4/main.dart';
import 'package:practice_4/stopwatch_card.dart';
import 'package:practice_4/tap_card.dart';
import 'package:practice_4/two_way_counter.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('tap count survives rotating the phone', (tester) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(1179, 2556); // iPhone 15, portrait
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Tap this card'));
    }
    tester.view.physicalSize = const Size(2556, 1179); // landscape
    await tester.pump(); // an overflow in landscape would fail the test here

    final taps = find.descendant(
      of: find.byType(TapCard),
      matching: find.text('3'),
    );
    expect(taps, findsOneWidget);
  });

  testWidgets('TapCard: Cancel keeps the count, Reset zeroes it', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const TapCard()));

    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byType(TapCard));
    }
    await tester.pump();
    expect(find.text('10'), findsOneWidget);

    await tester.longPress(find.byType(TapCard));
    await tester.pumpAndSettle();
    expect(find.text('Reset the count?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('10'), findsOneWidget);

    await tester.longPress(find.byType(TapCard));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('TwoWayCounter: − is disabled at zero via onPressed: null', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const TwoWayCounter()));
    OutlinedButton minus() => tester.widget(find.byType(OutlinedButton));

    expect(minus().onPressed, isNull);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(minus().onPressed, isNotNull);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    expect(minus().onPressed, isNull);
  });

  testWidgets('TwoWayCounter: Save spins, ignores a second tap, says Saved', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const TwoWayCounter()));

    await tester.tap(find.text('Save'));
    await tester.pump();
    final save = find.ancestor(
      of: find.byType(CircularProgressIndicator),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    await tester.tap(save); // disabled while saving: must not start a 2nd save

    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Saved'), findsOneWidget);

    // A second save would queue a second SnackBar behind the first one.
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('StopwatchCard: one timer only, Stop halts, Reset zeroes', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const StopwatchCard()));
    expect(find.text('00:00'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.tap(find.text('Start')); // no frame yet: hits the guard
    await tester.pump(const Duration(seconds: 65));
    expect(find.text('01:05'), findsOneWidget); // 02:10 with two timers

    await tester.tap(find.text('Stop'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('01:05'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Reset'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('StopwatchCard: removing it while running cancels the timer', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const StopwatchCard()));
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:02'), findsOneWidget);

    // Same as swapping StopwatchCard() for SizedBox() and hot reloading.
    // Without dispose() this throws "setState() called after dispose()".
    await tester.pumpWidget(_host(const SizedBox()));
    await tester.pump(const Duration(seconds: 3));
  });
}

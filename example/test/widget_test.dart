// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:example/main.dart';
import 'package:example/model/custom_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(
          customData: CustomData(
            templateId: 67020,
            channelId: '_ZeUTxl',
            calendarEventId: '63996425afcec577cce94f0b',
            scopes: ['name', 'gender'],
            serviceTerms: ['option'],
          ),
          pendingSchemeUri: ValueNotifier<Uri?>(null),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

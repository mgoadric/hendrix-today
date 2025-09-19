import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hendrix_today_app/objects/event.dart';
import 'package:hendrix_today_app/objects/event_type.dart';
import 'package:hendrix_today_app/widgets/event_dialog.dart';
import 'package:hendrix_today_app/widgets/rich_description.dart';

void main() {
  testWidgets('Event dialogs display event information', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EventDialog(
          event: HDXEvent(
            title: 'Test Title',
            desc: 'Test description.',
            eventType: EventType.event,
            date: DateTime(2023, 6, 25),
            time: '12:30 PM',
            location: '123 Main St.',
            contactName: 'Jane Smith',
            contactEmail: 'smith@email.com',
            beginPosting: DateTime(2023, 6, 20),
            endPosting: DateTime(2023, 6, 25),
            applyDeadline: DateTime(1234, 5, 6),
            id: 1,
            hip: false,
          ),
        ),
      ),
    ));

    await widgetTester.pumpAndSettle();

    expect(find.text('Test Title'), findsOneWidget,
        reason: 'The event title should be visible');
    expect(find.byType(RichDescription), findsOneWidget,
        reason: 'The event description should be visible');
    expect(find.text('∙ 12:30 PM'), findsOneWidget,
        reason: 'The event time should be visible');
    expect(find.text('∙ 123 Main St.'), findsOneWidget,
        reason: 'The event location should be visible');
    expect(find.text('Sat, May 6, 1234'), findsOneWidget,
        reason: 'The event deadline should be visible');
  });
}

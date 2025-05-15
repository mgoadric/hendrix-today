import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hendrix_today_app/objects/event.dart';
import 'package:hendrix_today_app/objects/event_type.dart';
import 'package:hendrix_today_app/widgets/event_card.dart';
import 'package:hendrix_today_app/widgets/event_dialog.dart';

void main() {
  testWidgets('Event cards display the event title', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EventCard(
          event: HDXEvent(
            title: 'Test Title',
            desc: 'Test description.',
            eventType: EventType.event,
            date: DateTime(2023, 6, 25),
            time: '12:30 PM',
            location: null,
            contactName: 'Jane Smith',
            contactEmail: 'smith@email.com',
            beginPosting: DateTime(2023, 6, 20),
            endPosting: DateTime(2023, 6, 25),
            applyDeadline: null,
            id: 1,
            hip: false,
          ),
        ),
      ),
    ));
    await widgetTester.pumpAndSettle();

    expect(find.text('Test Title'), findsOneWidget,
        reason: 'The event title should be visible');
  });

  testWidgets(
    'Clicking an event card creates an event dialog',
    (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: HDXEvent(
              title: 'Test Title',
              desc: 'Test description.',
              eventType: EventType.event,
              date: DateTime(2023, 6, 25),
              time: '12:30 PM',
              location: null,
              contactName: 'Jane Smith',
              contactEmail: 'smith@email.com',
              beginPosting: DateTime(2023, 6, 20),
              endPosting: DateTime(2023, 6, 25),
              applyDeadline: null,
              id: 1,
              hip: false,
            ),
          ),
        ),
      ));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(EventCard));
      await widgetTester.pumpAndSettle();

      expect(find.byType(EventDialog), findsOneWidget,
          reason: 'Clicking an event card should create an event dialog');
    },
  );
}

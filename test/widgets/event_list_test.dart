import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hendrix_today_app/objects/event.dart';
import 'package:hendrix_today_app/objects/event_type.dart';
import 'package:hendrix_today_app/widgets/event_card.dart';
import 'package:hendrix_today_app/widgets/event_list.dart';

void main() {
  testWidgets('Event lists display event cards', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventList(
            events: [
              HDXEvent(
                title: 'Test Title',
                desc: 'Test description.',
                eventType: EventType.event,
                date: DateTime(2023, 6, 28),
                time: '5pm',
                location: '123 Oak Street',
                contactName: 'Jane Smith',
                contactEmail: 'smith@email.com',
                beginPosting: DateTime(2023, 6, 21),
                endPosting: DateTime(2023, 6, 27),
                applyDeadline: null,
                id: 1,
                hip: false,
              ),
              HDXEvent(
                  title: 'Another Test Title',
                  desc: 'Test description 2.',
                  eventType: EventType.meeting,
                  date: DateTime(2023, 6, 18),
                  time: '10 am',
                  location: '123 Oak Street',
                  contactName: 'Jane Smith',
                  contactEmail: 'smith@email.com',
                  beginPosting: DateTime(2023, 6, 10),
                  endPosting: DateTime(2023, 6, 15),
                  applyDeadline: null,
                  id: 2,
                  hip: true),
            ],
          ),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    expect(find.byType(EventCard), findsNWidgets(2),
        reason: 'There should be one event card per event in the list');
  });
}

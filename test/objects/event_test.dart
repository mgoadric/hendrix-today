import 'package:flutter_test/flutter_test.dart';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:hendrix_today_app/objects/event.dart';
import 'package:hendrix_today_app/objects/event_type.dart';

void main() {
  // Do not alter
  final testData = <Map<String, dynamic>>[
    {
      "title": "Test Event",
      "desc": "Test description",
      "type": "Meeting",
      "date": Timestamp.fromDate(DateTime(2023, 6, 21)),
      "time": "5pm",
      "location": "Test location, 123 Main St.",
      "contactName": "Jane Smith",
      "contactEmail": "smith@email.com",
      "beginPosting": Timestamp.fromDate(DateTime(2023, 6, 11)),
      "endPosting": Timestamp.fromDate(DateTime(2023, 6, 17)),
      "applyDeadline": Timestamp.fromDate(DateTime(2023, 6, 17)),
      "id": 100,
    },
    {
      "title": "Minimal Event Data",
      "desc": "lorem ipsum",
      "type": "Announcement",
      "date": Timestamp.fromDate(DateTime(2023, 6, 1)),
      "contactName": "foo",
      "contactEmail": "bar@baz.com",
      "beginPosting": Timestamp.fromDate(DateTime(2023, 5, 25)),
      "endPosting": Timestamp.fromDate(DateTime(2023, 5, 31)),
      "id": 101,
    },
  ];
  final testEvents = <HDXEvent>[
    HDXEvent(
      title: "Later Event",
      desc: "foo",
      eventType: EventType.event,
      date: DateTime(2023, 1, 2),
      time: null,
      location: null,
      contactName: "Jane Smith",
      contactEmail: "smith@email.com",
      beginPosting: DateTime(2022, 12, 21),
      endPosting: DateTime(2022, 12, 27),
      applyDeadline: DateTime(2022, 12, 28),
      id: 1,
      hip: false,
    ),
    HDXEvent(
      title: "Earlier Event",
      desc: "bar",
      eventType: EventType.event,
      date: DateTime(2023, 1, 1),
      time: null,
      location: null,
      contactName: "Jane Smith",
      contactEmail: "smith@email.com",
      beginPosting: DateTime(2022, 12, 25),
      endPosting: DateTime(2022, 12, 31),
      applyDeadline: null,
      id: 2,
      hip: false,
    ),
  ];

  test('Events can be created from Firestore data', () {
    final testEvents =
        testData.map((data) => HDXEvent.fromFirebase(data)).toList();

    expect(testEvents.length, 2, reason: "Two events should have been created");
    final event = testEvents[0] as HDXEvent;
    expect(event.title, "Test Event");
    expect(event.desc, "Test description");
    expect(event.eventType, EventType.meeting);
    expect(event.date.year, 2023);
    expect(event.date.month, 6);
    expect(event.date.day, 21);
    expect(event.time, "5pm");
    expect(event.location, "Test location, 123 Main St.");
    expect(event.contactName, "Jane Smith");
    expect(event.contactEmail, "smith@email.com");
    expect(event.beginPosting.day, 11);
    expect(event.endPosting.day, 17);
    expect(event.applyDeadline?.day, 17);
    expect(event.id, 100);
  });

  test('Missing required fields should fail Event construction', () {
    final minimalEventData = testData[1];
    for (String requiredField in minimalEventData.keys) {
      final Map<String, dynamic> badData = Map.from(minimalEventData);
      badData.remove(requiredField);

      final invalidEvent = HDXEvent.fromFirebase(badData);

      expect(invalidEvent, null,
          reason: "A missing required field (in this case, $requiredField) "
              "should invalidate the event construction");
    }
  });

  test('Events are sortable by date', () {
    final laterEvent = testEvents[0];
    final earlierEvent = testEvents[1];
    final events = [laterEvent, earlierEvent];

    expect(events[0].title, "Later Event",
        reason: "The events have not yet been sorted");

    events.sort((a, b) => a.compareByDate(b));

    expect(events[0].title, "Earlier Event",
        reason: "The events should be sorted by date");
  });

  test('Event dates and deadlines are formatted nicely', () {
    final testDisplayDate = testEvents[0].displayDate();

    expect(testDisplayDate, "Mon, Jan 2, 2023",
        reason: "Dates should be formatted EEE, MMM d, yyyy");

    final testDisplayDeadline = testEvents[0].displayDeadline();

    expect(testDisplayDeadline, "Wed, Dec 28, 2022",
        reason: "Dates should be formatted EEE, MMM d, yyyy");
  });

  test('Events are searchable by title and description content', () {
    final eventSearchCount =
        testEvents.where((HDXEvent e) => e.containsString("EVENT")).length;

    expect(eventSearchCount, 2,
        reason: "Both of the test events contain the word 'event'");

    final fooSearchCount =
        testEvents.where((HDXEvent e) => e.containsString("foo")).length;

    expect(fooSearchCount, 1,
        reason: "Only one of the test events contains the word 'foo'");

    final gibberishSearchCount = testEvents
        .where((HDXEvent e) => e.containsString("argliujreabnva"))
        .length;

    expect(gibberishSearchCount, 0,
        reason: "None of the test events contain 'argliujreabnva'");
  });

  test('Events can be filtered by date', () {
    final goodDateFilterLength = testEvents
        .where((HDXEvent e) => e.matchesDate(DateTime(2023, 1, 1)))
        .length;

    expect(goodDateFilterLength, 1,
        reason:
            "There should be exactly one test event with the date 2023/1/1");

    final badDateFilterLength = testEvents
        .where((HDXEvent e) => e.matchesDate(DateTime(1234, 5, 6)))
        .length;

    expect(badDateFilterLength, 0,
        reason: "There should be no test events with the date 1234/5/6");
  });

  test('Events can be filtered by posting range', () {
    final overlapRangeFilterLength = testEvents
        .where((HDXEvent e) => e.inPostingRange(DateTime(2022, 12, 26)))
        .length;

    expect(overlapRangeFilterLength, 2,
        reason: "Both test events should be displayed on 2022/12/26");

    final rangeFilterStartLength = testEvents
        .where((HDXEvent e) => e.inPostingRange(DateTime(2022, 12, 21)))
        .length;

    expect(rangeFilterStartLength, 1,
        reason: "The range filter should include beginPosting dates");

    final rangeFilterEndLength = testEvents
        .where((HDXEvent e) => e.inPostingRange(DateTime(2022, 12, 31)))
        .length;

    expect(rangeFilterEndLength, 1,
        reason: "The range filter should include endPosting dates");

    final badRangeFilterLength = testEvents
        .where((HDXEvent e) => e.inPostingRange(DateTime(1234, 5, 6)))
        .length;

    expect(badRangeFilterLength, 0,
        reason: "No test events should be posted on 1234/5/6");
  });
}

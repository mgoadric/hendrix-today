import 'package:flutter/material.dart';

/// The types of event data.
///
/// This enum corresponds to the "Event type" field in the Hendrix Today
/// Submission Form, so it provides a lenient [fromString] method.
enum EventType {
  event,
  announcement,
  athletics,
  meeting;

  @override
  String toString() {
    switch (this) {
      case event:
        return "Event";
      case announcement:
        return "Announcement";
      case meeting:
        return "Meeting";
      case athletics:
        return "Athletics";
      }
  }

  /// Reads an [EventType] from a string.
  ///
  /// Used for interpreting event type data stored in a Firestore string. The
  /// interpretation is not case-sensitive and allows for plural strings (e.g.,
  /// both "event" and "events" would return [EventType.event]).
  static EventType? fromString(String? str) {
    switch (str?.trim().toLowerCase()) {
      case "event":
      case "events":
        return event;
      case "announcement":
      case "announcements":
      case "lost & found":
        return announcement;
      case "meeting":
      case "meetings":
        return meeting;
      case "athletics":
        return athletics;
      default:
        return null;
    }
  }

  /// Checks if this [EventType] matches the given [EventTypeFilter].
  ///
  /// Attempting to match a `null` filter will return `false`.
  bool matchesFilter(EventTypeFilter? filter) {
    switch (filter) {
      case EventTypeFilter.events:
        return this == event;
      case EventTypeFilter.announcements:
        return this == announcement;
      case EventTypeFilter.meetings:
        return this == meeting;
      case EventTypeFilter.athletics:
        return this == athletics;
      case EventTypeFilter.all:
        return true;
      case null:
        return false;
    }
  }

  /// Provides a color code for this [EventType] based on the current
  /// [ColorScheme].
  Color color(BuildContext context) {
    switch (this) {
      case event:
        return  Theme.of(context).colorScheme.primary;
      case announcement:
        return Theme.of(context).colorScheme.secondary;
      case meeting:
        return Theme.of(context).colorScheme.tertiary;
      case athletics:
        return Theme.of(context).colorScheme.onError;
    }
  }
}

/// Filters to apply to [EventType]s for aid in search methods.
enum EventTypeFilter {
  /// Allows all [EventType]s.
  all,

  /// Allows only [EventType.event]s.
  events,

  /// Allows only [EventType.announcement]s.
  announcements,

  athletics,

  /// Allows only [EventType.meeting]s.
  meetings;

  @override
  String toString() {
    switch (this) {
      case events:
        return "Events";
      case announcements:
        return "Announcements";
      case meetings:
        return "Meetings";
      case athletics:
        return "Athletics";
      case all:
        return "All";
    }
  }
}

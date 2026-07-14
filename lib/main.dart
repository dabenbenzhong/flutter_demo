import 'package:flutter/material.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';

void main() {
  runApp(CalendarApp(eventStore: FileCalendarEventStore()));
}

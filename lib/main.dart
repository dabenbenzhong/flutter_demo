import 'package:flutter/material.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final eventStore = await FileCalendarEventStore.createDefault();
  runApp(CalendarApp(eventStore: eventStore));
}

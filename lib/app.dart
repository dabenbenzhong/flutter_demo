import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class CalendarApp extends StatelessWidget {
  CalendarApp({CalendarEventStore? eventStore, super.key})
    : eventStore = eventStore ?? MemoryCalendarEventStore();

  final CalendarEventStore eventStore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日历',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: CalendarHomeScreen(eventStore: eventStore),
    );
  }
}

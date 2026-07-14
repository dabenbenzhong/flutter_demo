import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';

class CalendarApp extends StatelessWidget {
  CalendarApp({CalendarEventStore? eventStore, super.key})
    : eventStore = eventStore ?? MemoryCalendarEventStore();

  final CalendarEventStore eventStore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日历',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffc47d35),
          brightness: Brightness.light,
        ),
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xfff7eee5),
        useMaterial3: true,
      ),
      home: CalendarHomeScreen(eventStore: eventStore),
    );
  }
}

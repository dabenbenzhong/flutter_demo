import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/widgets/event_form_sheet.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/agenda_section.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_bottom_navigation.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_header.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';
import 'package:my_flutter_demo/features/calendar/widgets/inspiration_banner.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_date_utils.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_time_utils.dart';

class CalendarHomeScreen extends StatefulWidget {
  const CalendarHomeScreen({
    this.initialSelectedDate,
    this.initialEvents = const [],
    this.eventStore,
    super.key,
  });

  final DateTime? initialSelectedDate;
  final List<CalendarEvent> initialEvents;
  final CalendarEventStore? eventStore;

  @override
  State<CalendarHomeScreen> createState() => _CalendarHomeScreenState();
}

class _CalendarHomeScreenState extends State<CalendarHomeScreen> {
  late DateTime _selectedDate;
  late final CalendarEventStore _eventStore;
  late final List<CalendarEvent> _events;
  var _eventMutationVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate ?? DateTime(2026, 7, 13);
    _eventStore =
        widget.eventStore ?? MemoryCalendarEventStore(widget.initialEvents);
    _events = List.of(widget.initialEvents);
    _loadStoredEvents();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents =
        _events
            .where((event) => isSameCalendarDate(event.date, _selectedDate))
            .toList()
          ..sort(_compareEventsByStartTime);

    return Scaffold(
      extendBody: true,
      body: _CalendarBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 430),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 96),
                child: Column(
                  children: [
                    CalendarHeader(),
                    CalendarMonthCard(
                      selectedDate: _selectedDate,
                      onDateSelected: _selectDate,
                      events: _events,
                    ),
                    SizedBox(height: 16),
                    AgendaSection(
                      selectedDate: _selectedDate,
                      events: selectedEvents,
                      onDeleteEvent: _confirmDeleteEvent,
                    ),
                    SizedBox(height: 16),
                    InspirationBanner(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AddEventButton(onPressed: _showAddEventSheet),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CalendarBottomNavigation(),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _showAddEventSheet() async {
    final event = await showModalBottomSheet<CalendarEvent>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => EventFormSheet(selectedDate: _selectedDate),
    );

    if (event == null) {
      return;
    }

    setState(() {
      _eventMutationVersion++;
      _events.add(event);
    });
    await _eventStore.saveEvents(_events);
  }

  Future<void> _confirmDeleteEvent(CalendarEvent event) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除事项？'),
        content: Text('确认删除“${event.title}”吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _eventMutationVersion++;
      _events.remove(event);
    });
    await _eventStore.saveEvents(_events);
  }

  Future<void> _loadStoredEvents() async {
    final loadVersion = _eventMutationVersion;
    final storedEvents = await _eventStore.loadEvents();
    if (!mounted || loadVersion != _eventMutationVersion) {
      return;
    }

    setState(() {
      _events
        ..clear()
        ..addAll(storedEvents);
    });
  }
}

int _compareEventsByStartTime(CalendarEvent left, CalendarEvent right) {
  final leftMinutes = parseClockTimeToMinutes(left.time) ?? 0;
  final rightMinutes = parseClockTimeToMinutes(right.time) ?? 0;
  return leftMinutes.compareTo(rightMinutes);
}

class _CalendarBackground extends StatelessWidget {
  const _CalendarBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xfffff1df), Color(0xfff8eadc), Color(0xfff3e6dc)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _SoftBackgroundPainter()),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _SoftBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);

    glowPaint.color = Colors.white.withValues(alpha: 0.72);
    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.18),
      116,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.34),
      96,
      glowPaint,
    );

    glowPaint.color = const Color(0xffd8a467).withValues(alpha: 0.18);
    canvas.drawCircle(
      Offset(size.width * 0.66, size.height * 0.12),
      110,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.8),
      120,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

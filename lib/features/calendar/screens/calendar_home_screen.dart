import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/features/calendar/widgets/event_form_sheet.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/agenda_section.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';
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
  late final List<TodoItem> _todos;
  var _selectedTabIndex = 0;
  var _dataMutationVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate ?? DateTime(2026, 7, 13);
    _eventStore =
        widget.eventStore ?? MemoryCalendarEventStore(widget.initialEvents);
    _events = List.of(widget.initialEvents);
    _todos = [];
    _loadStoredData();
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
      body: _CalendarBackground(child: _buildSelectedPage(selectedEvents)),
      floatingActionButton: _selectedTabIndex == 0
          ? AddEventButton(onPressed: _showAddEventSheet)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CalendarBottomNavigation(
        selectedIndex: _selectedTabIndex,
        onSelected: _selectTab,
      ),
    );
  }

  Widget _buildSelectedPage(List<CalendarEvent> selectedEvents) {
    return switch (_selectedTabIndex) {
      0 => _CalendarPage(
        selectedDate: _selectedDate,
        selectedEvents: selectedEvents,
        events: _events,
        onDateSelected: _selectDate,
        onDeleteEvent: _confirmDeleteEvent,
      ),
      1 => _SchedulePage(
        events: _events,
        onGoToCalendar: () => _selectTab(0),
        onDeleteEvent: _confirmDeleteEvent,
      ),
      2 => _TodoPage(todos: _todos),
      _ => _ProfilePage(eventCount: _events.length, todoCount: _todos.length),
    };
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
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
      _dataMutationVersion++;
      _events.add(event);
    });
    await _eventStore.saveData(LocalCalendarData(events: _events, todos: _todos));
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
      _dataMutationVersion++;
      _events.remove(event);
    });
    await _eventStore.saveData(LocalCalendarData(events: _events, todos: _todos));
  }

  Future<void> _loadStoredData() async {
    final loadVersion = _dataMutationVersion;
    final storedData = await _eventStore.loadData();
    if (!mounted || loadVersion != _dataMutationVersion) {
      return;
    }

    setState(() {
      _events
        ..clear()
        ..addAll(storedData.events);
      _todos
        ..clear()
        ..addAll(storedData.todos);
    });
  }
}

int _compareEventsByStartTime(CalendarEvent left, CalendarEvent right) {
  final leftMinutes = parseClockTimeToMinutes(left.time) ?? 0;
  final rightMinutes = parseClockTimeToMinutes(right.time) ?? 0;
  return leftMinutes.compareTo(rightMinutes);
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({
    required this.selectedDate,
    required this.selectedEvents,
    required this.events,
    required this.onDateSelected,
    required this.onDeleteEvent,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> selectedEvents;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<CalendarEvent> onDeleteEvent;

  @override
  Widget build(BuildContext context) {
    return _PageContainer(
      child: Column(
        children: [
          const CalendarHeader(),
          CalendarMonthCard(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
            events: events,
          ),
          const SizedBox(height: 16),
          AgendaSection(
            selectedDate: selectedDate,
            events: selectedEvents,
            onDeleteEvent: onDeleteEvent,
          ),
          const SizedBox(height: 16),
          const InspirationBanner(),
        ],
      ),
    );
  }
}

class _SchedulePage extends StatelessWidget {
  const _SchedulePage({
    required this.events,
    required this.onGoToCalendar,
    required this.onDeleteEvent,
  });

  final List<CalendarEvent> events;
  final VoidCallback onGoToCalendar;
  final ValueChanged<CalendarEvent> onDeleteEvent;

  @override
  Widget build(BuildContext context) {
    final sortedEvents = List.of(events)..sort(_compareEventsByDateTime);

    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PageTitle(title: '日程', subtitle: '按日期查看全部本地事项'),
          const SizedBox(height: 14),
          if (sortedEvents.isEmpty)
            AppGlassCard(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
              child: Column(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: caramel,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '还没有事项',
                    style: TextStyle(
                      color: warmBrown,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: onGoToCalendar,
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: const Text('去日历页添加'),
                  ),
                ],
              ),
            )
          else
            for (final group in _groupEventsByDate(sortedEvents)) ...[
              _ScheduleDateGroup(
                date: group.date,
                events: group.events,
                onDeleteEvent: onDeleteEvent,
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _TodoPage extends StatelessWidget {
  const _TodoPage({required this.todos});

  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PageTitle(title: '待办', subtitle: '管理轻量清单'),
          const SizedBox(height: 14),
          AppGlassCard(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
            child: Column(
              children: [
                const Icon(Icons.check_box_rounded, color: caramel, size: 36),
                const SizedBox(height: 12),
                Text(
                  todos.isEmpty ? '还没有待办' : '待办项 ${todos.length}',
                  style: const TextStyle(
                    color: warmBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.eventCount, required this.todoCount});

  final int eventCount;
  final int todoCount;

  @override
  Widget build(BuildContext context) {
    return _PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PageTitle(title: '我的', subtitle: '本地应用信息'),
          const SizedBox(height: 14),
          AppGlassCard(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '日历',
                  style: TextStyle(
                    color: warmBrown,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '本地日历专注记录事项和待办项，数据保存在当前设备内。',
                  style: TextStyle(
                    color: warmBrown.withValues(alpha: 0.72),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 18),
                _StatRow(label: '事项数量', value: eventCount),
                const SizedBox(height: 10),
                _StatRow(label: '待办项数量', value: todoCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageContainer extends StatelessWidget {
  const _PageContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: warmBrown,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: warmBrown.withValues(alpha: 0.72),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: warmBrown,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            color: caramel,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ScheduleDateGroup extends StatelessWidget {
  const _ScheduleDateGroup({
    required this.date,
    required this.events,
    required this.onDeleteEvent,
  });

  final DateTime date;
  final List<CalendarEvent> events;
  final ValueChanged<CalendarEvent> onDeleteEvent;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.year}年${date.month}月${date.day}日',
            style: const TextStyle(
              color: warmBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          for (final event in events) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 38,
                  decoration: BoxDecoration(
                    color: event.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: warmBrown,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${event.time} - ${event.endTime}',
                        style: TextStyle(
                          color: warmBrown.withValues(alpha: 0.68),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: ValueKey(
                    'delete-schedule-event-${event.date.year}-${event.date.month}-${event.date.day}-${event.time}-${event.title}',
                  ),
                  tooltip: '删除事项',
                  onPressed: () => onDeleteEvent(event),
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: warmBrown.withValues(alpha: 0.62),
                ),
              ],
            ),
            if (event != events.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _EventDateGroup {
  const _EventDateGroup({required this.date, required this.events});

  final DateTime date;
  final List<CalendarEvent> events;
}

List<_EventDateGroup> _groupEventsByDate(List<CalendarEvent> events) {
  final groups = <_EventDateGroup>[];
  for (final event in events) {
    final date = DateTime(event.date.year, event.date.month, event.date.day);
    if (groups.isEmpty || !isSameCalendarDate(groups.last.date, date)) {
      groups.add(_EventDateGroup(date: date, events: [event]));
    } else {
      groups.last.events.add(event);
    }
  }
  return groups;
}

int _compareEventsByDateTime(CalendarEvent left, CalendarEvent right) {
  final dateCompare = DateTime(
    left.date.year,
    left.date.month,
    left.date.day,
  ).compareTo(DateTime(right.date.year, right.date.month, right.date.day));
  if (dateCompare != 0) {
    return dateCompare;
  }

  return _compareEventsByStartTime(left, right);
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

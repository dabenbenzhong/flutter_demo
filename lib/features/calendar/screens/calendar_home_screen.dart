import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/agenda_section.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_bottom_navigation.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_header.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';
import 'package:my_flutter_demo/features/calendar/widgets/event_form_sheet.dart';
import 'package:my_flutter_demo/features/calendar/widgets/inspiration_banner.dart';
import 'package:my_flutter_demo/features/calendar/widgets/todo_form_sheet.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_date_utils.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_time_utils.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';

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
  late DateTime _visibleMonth;
  late final CalendarEventStore _eventStore;
  late final List<CalendarEvent> _events;
  late final List<TodoItem> _todos;
  var _selectedTabIndex = 0;
  var _dataMutationVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate ?? DateTime(2026, 7, 13);
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
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
      body: _buildSelectedPage(selectedEvents),
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
        visibleMonth: _visibleMonth,
        selectedDate: _selectedDate,
        selectedEvents: selectedEvents,
        events: _events,
        onDateSelected: _selectDate,
        onPreviousMonth: () => _changeVisibleMonth(-1),
        onNextMonth: () => _changeVisibleMonth(1),
        onDeleteEvent: _confirmDeleteEvent,
      ),
      1 => _SchedulePage(
        events: _events,
        onGoToCalendar: () => _selectTab(0),
        onDeleteEvent: _confirmDeleteEvent,
      ),
      2 => _TodoPage(
        todos: _todos,
        onAddTodo: _showAddTodoSheet,
        onToggleTodo: _toggleTodo,
        onDeleteTodo: _confirmDeleteTodo,
      ),
      _ => _ProfilePage(
        eventCount: _events.length,
        todoCount: _todos.length,
        onClearData: _confirmClearData,
      ),
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
      _visibleMonth = DateTime(date.year, date.month);
    });
  }

  void _changeVisibleMonth(int offset) {
    final targetMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + offset,
    );
    final targetLastDay = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      0,
    ).day;
    final selectedDay = _selectedDate.day > targetLastDay
        ? targetLastDay
        : _selectedDate.day;

    setState(() {
      _visibleMonth = targetMonth;
      _selectedDate = DateTime(
        targetMonth.year,
        targetMonth.month,
        selectedDay,
      );
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
    await _saveCurrentData();
  }

  Future<void> _confirmDeleteEvent(CalendarEvent event) async {
    final shouldDelete = await _confirmAction(
      title: '删除事项？',
      content: Text('确认删除“${event.title}”吗？'),
      confirmLabel: '删除',
    );

    if (!shouldDelete) {
      return;
    }

    setState(() {
      _dataMutationVersion++;
      _events.remove(event);
    });
    await _saveCurrentData();
  }

  Future<void> _showAddTodoSheet() async {
    final todo = await showModalBottomSheet<TodoItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TodoFormSheet(),
    );

    if (todo == null) {
      return;
    }

    setState(() {
      _dataMutationVersion++;
      _todos.add(todo);
    });
    await _saveCurrentData();
  }

  Future<void> _toggleTodo(TodoItem todo) async {
    final index = _todos.indexOf(todo);
    if (index == -1) {
      return;
    }

    setState(() {
      _dataMutationVersion++;
      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
    });
    await _saveCurrentData();
  }

  Future<void> _confirmDeleteTodo(TodoItem todo) async {
    final shouldDelete = await _confirmAction(
      title: '删除待办？',
      content: Text('确认删除“${todo.title}”吗？'),
      confirmLabel: '删除',
    );

    if (!shouldDelete) {
      return;
    }

    setState(() {
      _dataMutationVersion++;
      _todos.remove(todo);
    });
    await _saveCurrentData();
  }

  Future<void> _confirmClearData() async {
    final shouldClear = await _confirmAction(
      title: '清空本地数据？',
      content: const Text('这会删除当前设备内全部事项和待办项。'),
      confirmLabel: '清空',
    );

    if (!shouldClear) {
      return;
    }

    setState(() {
      _dataMutationVersion++;
      _events.clear();
      _todos.clear();
    });
    await _eventStore.clearData();
  }

  Future<bool> _confirmAction({
    required String title,
    required Widget content,
    required String confirmLabel,
  }) async {
    return showAppConfirmDialog(
      context: context,
      title: title,
      content: content,
      confirmLabel: confirmLabel,
    );
  }

  Future<void> _saveCurrentData() async {
    await _eventStore.saveData(
      LocalCalendarData(events: _events, todos: _todos),
    );
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

int _compareTodos(TodoItem left, TodoItem right) {
  if (left.isCompleted != right.isCompleted) {
    return left.isCompleted ? 1 : -1;
  }

  return right.createdAt.compareTo(left.createdAt);
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({
    required this.visibleMonth,
    required this.selectedDate,
    required this.selectedEvents,
    required this.events,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDeleteEvent,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<CalendarEvent> selectedEvents;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<CalendarEvent> onDeleteEvent;

  @override
  Widget build(BuildContext context) {
    return AppPageContainer(
      child: Column(
        children: [
          CalendarHeader(
            visibleMonth: visibleMonth,
            onPreviousMonth: onPreviousMonth,
            onNextMonth: onNextMonth,
          ),
          CalendarMonthCard(
            visibleMonth: visibleMonth,
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

    return AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageTitle(title: '日程', subtitle: '按日期查看全部本地事项'),
          const SizedBox(height: 14),
          if (sortedEvents.isEmpty)
            AppEmptyState(
              icon: Icons.event_available_rounded,
              title: '还没有事项',
              description: '去日历页添加一个事项后，会在这里按日期汇总。',
              actionLabel: '去日历页添加',
              actionIcon: Icons.calendar_month_rounded,
              onAction: onGoToCalendar,
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
  const _TodoPage({
    required this.todos,
    required this.onAddTodo,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  });

  final List<TodoItem> todos;
  final VoidCallback onAddTodo;
  final ValueChanged<TodoItem> onToggleTodo;
  final ValueChanged<TodoItem> onDeleteTodo;

  @override
  Widget build(BuildContext context) {
    final sortedTodos = List.of(todos)..sort(_compareTodos);

    return AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageTitle(title: '待办', subtitle: '管理轻量清单'),
          const SizedBox(height: 14),
          if (sortedTodos.isEmpty)
            AppEmptyState(
              icon: Icons.check_box_rounded,
              title: '还没有待办',
              description: '新增轻量清单后，可以在这里切换完成状态。',
              actionLabel: '新增待办',
              actionIcon: Icons.add_task_rounded,
              onAction: onAddTodo,
            )
          else ...[
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onAddTodo,
                icon: const Icon(Icons.add_task_rounded),
                label: const Text('新增待办'),
              ),
            ),
            const SizedBox(height: 12),
            for (final todo in sortedTodos) ...[
              _TodoTile(
                todo: todo,
                onToggle: () => onToggleTodo(todo),
                onDelete: () => onDeleteTodo(todo),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  const _TodoTile({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppContentCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      child: Row(
        children: [
          Checkbox(
            key: ValueKey('toggle-todo-${todo.createdAt.toIso8601String()}'),
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: warmBrown,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    letterSpacing: 0,
                  ),
                ),
                if (todo.notes.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    todo.notes,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: warmBrown.withValues(alpha: 0.68),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            key: ValueKey('delete-todo-${todo.createdAt.toIso8601String()}'),
            tooltip: '删除待办',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: warmBrown.withValues(alpha: 0.62),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({
    required this.eventCount,
    required this.todoCount,
    required this.onClearData,
  });

  final int eventCount;
  final int todoCount;
  final VoidCallback onClearData;

  @override
  Widget build(BuildContext context) {
    return AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageTitle(title: '我的', subtitle: '本地应用信息'),
          const SizedBox(height: 14),
          AppContentCard(
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
                AppStatRow(label: '事项数量', value: eventCount),
                const SizedBox(height: 10),
                AppStatRow(label: '待办项数量', value: todoCount),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onClearData,
                    icon: const Icon(Icons.delete_sweep_rounded),
                    label: const Text('清空本地数据'),
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
    return AppContentCard(
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

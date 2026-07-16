import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';

class LocalCalendarData {
  LocalCalendarData({
    List<CalendarEvent> events = const [],
    List<TodoItem> todos = const [],
  }) : events = List.of(events),
       todos = List.of(todos);

  final List<CalendarEvent> events;
  final List<TodoItem> todos;

  int get eventCount => events.length;

  int get todoCount => todos.length;

  LocalCalendarData copyWith({
    List<CalendarEvent>? events,
    List<TodoItem>? todos,
  }) {
    return LocalCalendarData(
      events: events ?? this.events,
      todos: todos ?? this.todos,
    );
  }
}

abstract class CalendarEventStore {
  Future<LocalCalendarData> loadData();

  Future<void> saveData(LocalCalendarData data);

  Future<void> clearData();

  Future<List<CalendarEvent>> loadEvents() async {
    return (await loadData()).events;
  }

  Future<void> saveEvents(List<CalendarEvent> events) async {
    final data = await loadData();
    await saveData(data.copyWith(events: events));
  }

  Future<List<TodoItem>> loadTodos() async {
    return (await loadData()).todos;
  }

  Future<void> saveTodos(List<TodoItem> todos) async {
    final data = await loadData();
    await saveData(data.copyWith(todos: todos));
  }
}

class MemoryCalendarEventStore extends CalendarEventStore {
  MemoryCalendarEventStore([
    List<CalendarEvent> initialEvents = const [],
    List<TodoItem> initialTodos = const [],
  ]) : _data = LocalCalendarData(events: initialEvents, todos: initialTodos);

  var _data = LocalCalendarData();

  @override
  Future<LocalCalendarData> loadData() async {
    return LocalCalendarData(events: _data.events, todos: _data.todos);
  }

  @override
  Future<void> saveData(LocalCalendarData data) async {
    _data = LocalCalendarData(events: data.events, todos: data.todos);
  }

  @override
  Future<void> clearData() async {
    _data = LocalCalendarData();
  }
}

class FileCalendarEventStore extends CalendarEventStore {
  FileCalendarEventStore({File? file}) : _file = file ?? File(_defaultPath());

  final File _file;

  @override
  Future<LocalCalendarData> loadData() async {
    if (!await _file.exists()) {
      return LocalCalendarData();
    }

    try {
      final decoded = jsonDecode(await _file.readAsString());
      if (decoded is List<dynamic>) {
        return LocalCalendarData(events: _eventsFromJsonList(decoded));
      }

      if (decoded is! Map<String, dynamic>) {
        return LocalCalendarData();
      }

      final eventsJson = decoded['events'];
      final todosJson = decoded['todos'];

      return LocalCalendarData(
        events: eventsJson is List<dynamic>
            ? _eventsFromJsonList(eventsJson)
            : [],
        todos: todosJson is List<dynamic> ? _todosFromJsonList(todosJson) : [],
      );
    } on FormatException {
      return LocalCalendarData();
    }
  }

  @override
  Future<void> saveData(LocalCalendarData data) async {
    await _file.parent.create(recursive: true);
    final encoded = jsonEncode({
      'events': [for (final event in data.events) _eventToJson(event)],
      'todos': [for (final todo in data.todos) _todoToJson(todo)],
    });
    await _file.writeAsString(encoded);
  }

  @override
  Future<void> clearData() async {
    if (await _file.exists()) {
      await _file.delete();
    }
  }

  static String _defaultPath() {
    final root =
        Platform.environment['APPDATA'] ??
        Platform.environment['HOME'] ??
        Directory.current.path;
    return [
      root,
      'my_flutter_demo',
      'calendar_events.json',
    ].join(Platform.pathSeparator);
  }
}

List<CalendarEvent> _eventsFromJsonList(List<dynamic> items) {
  return [
    for (final item in items)
      if (item is Map<String, dynamic>) _eventFromJson(item),
  ];
}

List<TodoItem> _todosFromJsonList(List<dynamic> items) {
  return [
    for (final item in items)
      if (item is Map<String, dynamic>) _todoFromJson(item),
  ];
}

Map<String, Object?> _eventToJson(CalendarEvent event) {
  return {
    'year': event.date.year,
    'month': event.date.month,
    'day': event.date.day,
    'time': event.time,
    'endTime': event.endTime,
    'title': event.title,
    'notes': event.notes,
    'color': event.color.toARGB32(),
    'iconBackground': event.iconBackground.toARGB32(),
  };
}

CalendarEvent _eventFromJson(Map<String, dynamic> json) {
  final year = _readInt(json, 'year', DateTime.now().year);
  final month = _readInt(json, 'month', 1);
  final day = _readInt(json, 'day', 1);

  return CalendarEvent(
    date: DateTime(year, month, day),
    time: _readString(json, 'time'),
    endTime: _readString(json, 'endTime'),
    title: _readString(json, 'title'),
    notes: _readString(json, 'notes'),
    color: Color(_readInt(json, 'color', Colors.blue.toARGB32())),
    icon: Icons.event_note_rounded,
    iconBackground: Color(
      _readInt(json, 'iconBackground', const Color(0xffeef4ff).toARGB32()),
    ),
  );
}

Map<String, Object?> _todoToJson(TodoItem todo) {
  return {
    'title': todo.title,
    'notes': todo.notes,
    'isCompleted': todo.isCompleted,
    'createdAt': todo.createdAt.toIso8601String(),
  };
}

TodoItem _todoFromJson(Map<String, dynamic> json) {
  return TodoItem(
    title: _readString(json, 'title'),
    notes: _readString(json, 'notes'),
    isCompleted: _readBool(json, 'isCompleted'),
    createdAt:
        DateTime.tryParse(_readString(json, 'createdAt')) ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}

int _readInt(Map<String, dynamic> json, String key, int fallback) {
  final value = json[key];
  return value is int ? value : fallback;
}

bool _readBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is bool ? value : false;
}

String _readString(
  Map<String, dynamic> json,
  String key, [
  String fallback = '',
]) {
  final value = json[key];
  return value is String ? value : fallback;
}

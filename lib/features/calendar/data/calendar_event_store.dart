import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';

abstract class CalendarEventStore {
  Future<List<CalendarEvent>> loadEvents();

  Future<void> saveEvents(List<CalendarEvent> events);
}

class MemoryCalendarEventStore implements CalendarEventStore {
  MemoryCalendarEventStore([List<CalendarEvent> initialEvents = const []])
    : _events = List.of(initialEvents);

  var _events = <CalendarEvent>[];

  @override
  Future<List<CalendarEvent>> loadEvents() async {
    return List.of(_events);
  }

  @override
  Future<void> saveEvents(List<CalendarEvent> events) async {
    _events = List.of(events);
  }
}

class FileCalendarEventStore implements CalendarEventStore {
  FileCalendarEventStore({File? file}) : _file = file ?? File(_defaultPath());

  final File _file;

  @override
  Future<List<CalendarEvent>> loadEvents() async {
    if (!await _file.exists()) {
      return [];
    }

    try {
      final decoded = jsonDecode(await _file.readAsString());
      if (decoded is! List<dynamic>) {
        return [];
      }

      return [
        for (final item in decoded)
          if (item is Map<String, dynamic>) _eventFromJson(item),
      ];
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> saveEvents(List<CalendarEvent> events) async {
    await _file.parent.create(recursive: true);
    final encoded = jsonEncode([
      for (final event in events) _eventToJson(event),
    ]);
    await _file.writeAsString(encoded);
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

int _readInt(Map<String, dynamic> json, String key, int fallback) {
  final value = json[key];
  return value is int ? value : fallback;
}

String _readString(
  Map<String, dynamic> json,
  String key, [
  String fallback = '',
]) {
  final value = json[key];
  return value is String ? value : fallback;
}

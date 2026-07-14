import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';

void main() {
  test(
    'FileCalendarEventStore round-trips calendar events through JSON',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'calendar-store-test-',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final file = File('${tempDir.path}${Platform.pathSeparator}events.json');
      final store = FileCalendarEventStore(file: file);

      await store.saveEvents([
        CalendarEvent(
          date: DateTime(2026, 7, 14),
          time: '10:00',
          endTime: '11:00',
          title: '读书',
          notes: '整理摘抄',
          color: greenMarker,
          icon: Icons.event_note_rounded,
          iconBackground: const Color(0xffeaf8ef),
        ),
      ]);

      final reloaded = await FileCalendarEventStore(file: file).loadEvents();

      expect(reloaded, hasLength(1));
      expect(reloaded.single.date, DateTime(2026, 7, 14));
      expect(reloaded.single.time, '10:00');
      expect(reloaded.single.endTime, '11:00');
      expect(reloaded.single.title, '读书');
      expect(reloaded.single.notes, '整理摘抄');
      expect(reloaded.single.color, greenMarker);
      expect(reloaded.single.iconBackground, const Color(0xffeaf8ef));
    },
  );
}

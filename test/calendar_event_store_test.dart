import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';

void main() {
  test(
    'FileCalendarEventStore default store writes below platform app storage',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'calendar-store-default-test-',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final store = await FileCalendarEventStore.createDefault(
        getStorageDirectory: () async => tempDir,
      );

      await store.saveData(
        LocalCalendarData(
          todos: [
            TodoItem(
              title: '买菜',
              notes: '准备晚餐',
              createdAt: DateTime(2026, 7, 14, 9, 15),
            ),
          ],
        ),
      );

      final expectedFile = File(
        '${tempDir.path}${Platform.pathSeparator}calendar_events.json',
      );
      expect(await expectedFile.exists(), isTrue);

      final reloaded = await FileCalendarEventStore(
        file: expectedFile,
      ).loadData();

      expect(reloaded.todos, hasLength(1));
      expect(reloaded.todos.single.title, '买菜');
    },
  );

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

  test(
    'FileCalendarEventStore round-trips local data counts and clearing',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'calendar-store-test-',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final file = File('${tempDir.path}${Platform.pathSeparator}data.json');
      final store = FileCalendarEventStore(file: file);

      await store.saveData(
        LocalCalendarData(
          events: [
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
          ],
          todos: [
            TodoItem(
              title: '买菜',
              notes: '准备晚餐',
              isCompleted: true,
              createdAt: DateTime(2026, 7, 14, 9, 15),
            ),
          ],
        ),
      );

      final reloaded = await FileCalendarEventStore(file: file).loadData();

      expect(reloaded.events, hasLength(1));
      expect(reloaded.todos, hasLength(1));
      expect(reloaded.eventCount, 1);
      expect(reloaded.todoCount, 1);
      expect(reloaded.todos.single.title, '买菜');
      expect(reloaded.todos.single.notes, '准备晚餐');
      expect(reloaded.todos.single.isCompleted, isTrue);
      expect(reloaded.todos.single.createdAt, DateTime(2026, 7, 14, 9, 15));

      await FileCalendarEventStore(file: file).clearData();

      final cleared = await FileCalendarEventStore(file: file).loadData();

      expect(cleared.events, isEmpty);
      expect(cleared.todos, isEmpty);
      expect(cleared.eventCount, 0);
      expect(cleared.todoCount, 0);
    },
  );

  test(
    'loads legacy event-list JSON and saves it in the current format',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'calendar-store-legacy-test-',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File('${tempDir.path}${Platform.pathSeparator}legacy.json');
      await file.writeAsString(
        '[{"year":2026,"month":7,"day":13,"time":"10:00",'
        '"endTime":"11:00","title":"旧格式事项","notes":"旧备注",'
        '"color":4293958160,"iconBackground":4294963676}]',
      );
      final store = FileCalendarEventStore(file: file);

      final legacyData = await store.loadData();
      expect(legacyData.events.single.title, '旧格式事项');
      expect(legacyData.todos, isEmpty);

      final event = legacyData.events.single;
      await store.saveData(
        LocalCalendarData(
          events: [
            CalendarEvent(
              date: event.date,
              time: event.time,
              endTime: event.endTime,
              title: '已编辑旧格式事项',
              notes: event.notes,
              color: event.color,
              icon: event.icon,
              iconBackground: event.iconBackground,
            ),
          ],
        ),
      );
      final reloaded = await store.loadData();

      expect(reloaded.events.single.title, '已编辑旧格式事项');
      expect(reloaded.events.single.color, event.color);
      expect(reloaded.todos, isEmpty);
    },
  );
}

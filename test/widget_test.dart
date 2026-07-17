import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';

void main() {
  testWidgets(
    'bottom navigation opens four pages and preserves calendar state',
    (tester) async {
      await tester.pumpWidget(CalendarApp());

      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('日程'));
      await tester.pumpAndSettle();

      expect(find.text('还没有事项'), findsOneWidget);

      await tester.tap(find.text('待办'));
      await tester.pumpAndSettle();

      expect(find.text('还没有待办'), findsOneWidget);
      expect(find.text('新增轻量清单后，可以在这里切换完成状态。'), findsNothing);

      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      expect(find.text('事项数量'), findsOneWidget);

      await tester.tap(find.text('日历').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('selected-day-14')), findsOneWidget);
    },
  );

  testWidgets('calendar month controls keep selected day valid', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('31'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();

    expect(find.text('2026年8月'), findsOneWidget);
    expect(find.byKey(const ValueKey('selected-day-31')), findsOneWidget);

    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();

    expect(find.text('2026年9月'), findsOneWidget);
    expect(find.byKey(const ValueKey('selected-day-30')), findsOneWidget);

    await tester.tap(find.byTooltip('上个月'));
    await tester.pumpAndSettle();

    expect(find.text('2026年8月'), findsOneWidget);
    expect(find.byKey(const ValueKey('selected-day-30')), findsOneWidget);
  });

  testWidgets('creates events in the currently displayed month', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('日期：8月20日'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), '跨月安排');
    await tester.enterText(find.widgetWithText(TextFormField, '开始时间'), '10:00');
    await tester.enterText(find.widgetWithText(TextFormField, '结束时间'), '11:00');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('跨月安排'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('event-marker-2026-8-20')),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('上个月'));
    await tester.pumpAndSettle();

    expect(find.text('跨月安排'), findsNothing);
    expect(find.byKey(const ValueKey('event-marker-2026-8-20')), findsNothing);
  });

  testWidgets('todo page creates required-title todos and persists them', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore();

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(find.text('还没有待办'), findsOneWidget);

    await tester.tap(find.text('新增待办'));
    await tester.pumpAndSettle();

    expect(find.text('新增待办'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '标题'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '备注'), findsOneWidget);

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), '买菜');
    await tester.enterText(find.widgetWithText(TextFormField, '备注'), '准备晚餐');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('买菜'), findsOneWidget);
    expect(find.text('准备晚餐'), findsOneWidget);
    expect(find.text('还没有待办'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(find.text('买菜'), findsOneWidget);
    expect(find.text('准备晚餐'), findsOneWidget);
  });

  testWidgets('todo form clears required-title error after valid input', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('新增待办'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), 'Task1');
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsNothing);
  });

  testWidgets('add todo form exposes accessible field names', (tester) async {
    await _withSemantics(tester, () async {
      await tester.pumpWidget(CalendarApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('待办'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('新增待办'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('待办项标题'), findsOneWidget);
      expect(find.bySemanticsLabel('待办项备注'), findsOneWidget);
    });
  });

  testWidgets('todo page toggles sorts and confirms deletion', (tester) async {
    final oldCreatedAt = DateTime(2026, 7, 14, 9);
    final newCreatedAt = DateTime(2026, 7, 14, 10);
    final doneCreatedAt = DateTime(2026, 7, 14, 11);
    final store = MemoryCalendarEventStore([], [
      TodoItem(title: '旧待办', createdAt: oldCreatedAt),
      TodoItem(title: '新待办', createdAt: newCreatedAt),
      TodoItem(title: '已完成待办', isCompleted: true, createdAt: doneCreatedAt),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('新待办')).dy,
      lessThan(tester.getTopLeft(find.text('旧待办')).dy),
    );
    expect(
      tester.getTopLeft(find.text('旧待办')).dy,
      lessThan(tester.getTopLeft(find.text('已完成待办')).dy),
    );

    await tester.tap(find.byKey(_todoToggleKey(oldCreatedAt)));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('新待办')).dy,
      lessThan(tester.getTopLeft(find.text('已完成待办')).dy),
    );
    expect(
      tester.getTopLeft(find.text('已完成待办')).dy,
      lessThan(tester.getTopLeft(find.text('旧待办')).dy),
    );

    await tester.tap(find.byKey(_todoToggleKey(oldCreatedAt)));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('旧待办')).dy,
      lessThan(tester.getTopLeft(find.text('已完成待办')).dy),
    );

    await tester.tap(find.byKey(_todoDeleteKey(doneCreatedAt)));
    await tester.pumpAndSettle();

    expect(find.text('删除待办？'), findsOneWidget);
    expect(find.text('确认删除“已完成待办”吗？'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    expect(find.text('已完成待办'), findsOneWidget);

    await tester.tap(find.byKey(_todoDeleteKey(doneCreatedAt)));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await tester.pumpAndSettle();

    expect(find.text('已完成待办'), findsNothing);
  });

  testWidgets('todo checkbox exposes an accessible toggle name', (
    tester,
  ) async {
    await _withSemantics(tester, () async {
      final store = MemoryCalendarEventStore([], [
        TodoItem(title: 'Task1', createdAt: DateTime(2026, 7, 14, 9)),
      ]);

      await tester.pumpWidget(CalendarApp(eventStore: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('待办'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('切换 Task1 完成状态'), findsOneWidget);
    });
  });

  testWidgets('todo completion state persists after rebuilding the app', (
    tester,
  ) async {
    final oldCreatedAt = DateTime(2026, 7, 14, 11);
    final newCreatedAt = DateTime(2026, 7, 14, 10);
    final store = MemoryCalendarEventStore([], [
      TodoItem(title: '旧待办', createdAt: oldCreatedAt),
      TodoItem(title: '新待办', createdAt: newCreatedAt),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('旧待办')).dy,
      lessThan(tester.getTopLeft(find.text('新待办')).dy),
    );

    await tester.tap(find.byKey(_todoToggleKey(oldCreatedAt)));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('新待办')).dy,
      lessThan(tester.getTopLeft(find.text('旧待办')).dy),
    );
  });

  testWidgets('schedule page groups sorted events and deletes in shared data', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();
    await _createEvent(
      tester,
      title: '下午复盘',
      startTime: '15:00',
      endTime: '16:00',
    );
    await _createEvent(
      tester,
      title: '晨间计划',
      startTime: '09:00',
      endTime: '09:30',
    );

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await _createEvent(
      tester,
      title: '整理书架',
      startTime: '16:00',
      endTime: '17:00',
    );

    await tester.tap(find.text('日程'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsNothing);
    expect(
      tester.getTopLeft(find.text('2026年7月14日')).dy,
      lessThan(tester.getTopLeft(find.text('2026年7月15日')).dy),
    );
    expect(
      tester.getTopLeft(find.text('晨间计划')).dy,
      lessThan(tester.getTopLeft(find.text('下午复盘')).dy),
    );

    await tester.tap(find.byKey(_scheduleDeleteKey('2026-7-14-09:00-晨间计划')));
    await tester.pumpAndSettle();

    expect(find.text('删除事项？'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    expect(find.text('晨间计划'), findsOneWidget);

    await tester.tap(find.byKey(_scheduleDeleteKey('2026-7-14-09:00-晨间计划')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(_scheduleDeleteKey('2026-7-14-15:00-下午复盘')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('日历'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    expect(find.text('当天没有事项'), findsOneWidget);
    expect(find.byKey(const ValueKey('event-marker-2026-7-14')), findsNothing);

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(find.text('整理书架'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('event-marker-2026-7-15')),
      findsOneWidget,
    );
  });

  testWidgets('schedule empty state opens calendar page without a form', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('日程'));
    await tester.pumpAndSettle();

    expect(find.text('还没有事项'), findsOneWidget);

    await tester.tap(find.text('去日历页添加'));
    await tester.pumpAndSettle();

    expect(find.text('2026年7月'), findsOneWidget);
    expect(find.text('当天没有事项'), findsOneWidget);
    expect(find.text('新增事项'), findsNothing);
  });

  testWidgets('profile page clears local data and preserves calendar state', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore(
      [
        CalendarEvent(
          date: DateTime(2026, 7, 14),
          time: '10:00',
          endTime: '11:00',
          title: '读书',
          color: blueMarker,
          icon: Icons.event_note_rounded,
          iconBackground: const Color(0xffeef4ff),
        ),
      ],
      [TodoItem(title: '买菜', createdAt: DateTime(2026, 7, 14, 9))],
    );

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('31'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();

    expect(find.text('事项数量'), findsOneWidget);
    expect(find.text('待办项数量'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.text('清空本地数据'));
    await tester.pumpAndSettle();

    expect(find.text('清空本地数据？'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.text('清空本地数据'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '清空'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNWidgets(2));

    await tester.tap(find.text('日程'));
    await tester.pumpAndSettle();

    expect(find.text('还没有事项'), findsOneWidget);

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(find.text('还没有待办'), findsOneWidget);

    await tester.tap(find.text('日历').last);
    await tester.pumpAndSettle();

    expect(find.text('2026年9月'), findsOneWidget);
    expect(find.byKey(const ValueKey('selected-day-30')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('renders the July 2026 calendar dashboard', (tester) async {
    await tester.pumpWidget(CalendarApp());

    expect(find.text('2026年7月'), findsOneWidget);
    expect(find.byTooltip('上个月'), findsOneWidget);
    expect(find.byTooltip('下个月'), findsOneWidget);
    expect(find.text('7月13日'), findsOneWidget);
    expect(find.text('农历五月廿九'), findsOneWidget);
    expect(find.text('当天没有事项'), findsOneWidget);
    expect(find.text('每一天，都是更好的自己。'), findsOneWidget);

    for (final label in ['日历', '日程', '待办', '我的']) {
      expect(find.text(label), findsOneWidget);
    }

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('does not show a bare lunar label without lunar data', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('31'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();

    expect(find.text('9月30日'), findsOneWidget);
    expect(find.text('农历'), findsNothing);
  });

  testWidgets('month card exposes a five-week grid and selected day', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalendarMonthCard(
            visibleMonth: DateTime(2026, 7),
            selectedDate: DateTime(2026, 7, 13),
          ),
        ),
      ),
    );

    expect(find.byType(CalendarDayCell), findsNWidgets(35));
    expect(find.byKey(const ValueKey('selected-day-13')), findsOneWidget);
    expect(find.text('建党节'), findsOneWidget);
    expect(find.text('小暑'), findsOneWidget);
    expect(find.text('大暑'), findsOneWidget);
  });

  testWidgets('mobile dashboard uses compact typography and controls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(CalendarApp());

    final title = tester.widget<Text>(find.text('2026年7月'));
    expect(title.style?.fontSize, lessThanOrEqualTo(32));

    final selectedDay = tester.widget<Text>(find.text('13').first);
    expect(selectedDay.style?.fontSize, lessThanOrEqualTo(18));

    expect(tester.getSize(find.byType(AddEventButton)), const Size(64, 64));
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected date drives the agenda list and empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CalendarHomeScreen(initialEvents: todayEvents)),
    );

    expect(find.byKey(const ValueKey('selected-day-13')), findsOneWidget);
    expect(find.text('7月13日'), findsOneWidget);
    for (final event in todayEvents) {
      expect(find.text(event.title), findsOneWidget);
    }
    expect(find.text('当天没有事项'), findsNothing);

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('selected-day-14')), findsOneWidget);
    expect(find.text('7月14日'), findsOneWidget);
    expect(find.text('团队晨会'), findsNothing);
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('creates an item for the selected date from the bottom sheet', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('新增事项'), findsOneWidget);
    expect(find.text('日期：7月14日'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '标题'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '开始时间'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '结束时间'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '备注'), findsOneWidget);
    expect(find.text('蓝色'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), '读书');
    await tester.enterText(find.widgetWithText(TextFormField, '开始时间'), '10:00');
    await tester.enterText(find.widgetWithText(TextFormField, '结束时间'), '11:00');
    await tester.enterText(find.widgetWithText(TextFormField, '备注'), '整理摘抄');
    await tester.tap(find.widgetWithText(ChoiceChip, '绿色'));
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('新增事项'), findsNothing);
    expect(find.text('读书'), findsOneWidget);
    expect(find.text('11:00 · 整理摘抄'), findsOneWidget);
    expect(find.text('当天没有事项'), findsNothing);

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(find.text('读书'), findsNothing);
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('requires title and times before creating an item', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('新增事项'), findsOneWidget);
    expect(find.text('请填写'), findsNWidgets(3));
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('event form clears required-field errors after valid input', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsNWidgets(3));

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), 'QAEvent');
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsNWidgets(2));

    await tester.enterText(find.widgetWithText(TextFormField, '开始时间'), '10:00');
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, '结束时间'), '11:00');
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsNothing);
  });

  testWidgets('event form does not validate untouched fields before submit', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), 'QAEvent');
    await tester.pumpAndSettle();

    expect(find.text('请填写'), findsNothing);
  });

  testWidgets('add event form exposes accessible field names', (tester) async {
    await _withSemantics(tester, () async {
      await tester.pumpWidget(CalendarApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('事项标题'), findsOneWidget);
      expect(find.bySemanticsLabel('事项开始时间'), findsOneWidget);
      expect(find.bySemanticsLabel('事项结束时间'), findsOneWidget);
      expect(find.bySemanticsLabel('事项备注'), findsOneWidget);
    });
  });

  testWidgets('rejects items whose end time is not after the start time', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, '标题'), '午餐');
    await tester.enterText(find.widgetWithText(TextFormField, '开始时间'), '12:00');
    await tester.enterText(find.widgetWithText(TextFormField, '结束时间'), '11:30');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('新增事项'), findsOneWidget);
    expect(find.text('结束时间必须晚于开始时间'), findsOneWidget);
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('sorts same-day items by start time and marks event dates', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    await _createEvent(
      tester,
      title: '下午复盘',
      startTime: '15:00',
      endTime: '16:00',
    );
    await _createEvent(
      tester,
      title: '晨间计划',
      startTime: '09:00',
      endTime: '09:30',
    );

    expect(
      find.byKey(const ValueKey('event-marker-2026-7-14')),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.text('晨间计划')).dy,
      lessThan(tester.getTopLeft(find.text('下午复盘')).dy),
    );

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(find.text('晨间计划'), findsNothing);
    expect(
      find.byKey(const ValueKey('event-marker-2026-7-14')),
      findsOneWidget,
    );
  });

  testWidgets('keeps an item when delete confirmation is cancelled', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    await _createEvent(
      tester,
      title: '午间散步',
      startTime: '12:00',
      endTime: '12:30',
    );

    final walkDeleteButton = find.byKey(_deleteKey('2026-7-14-12:00-午间散步'));
    await tester.ensureVisible(walkDeleteButton);
    await tester.pumpAndSettle();
    await tester.tap(walkDeleteButton);
    await tester.pumpAndSettle();

    expect(find.text('删除事项？'), findsOneWidget);
    expect(find.text('确认删除“午间散步”吗？'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    expect(find.text('午间散步'), findsOneWidget);
    expect(find.text('当天没有事项'), findsNothing);
  });

  testWidgets('deletes a confirmed item without affecting other dates', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();
    await _createEvent(
      tester,
      title: '读书',
      startTime: '10:00',
      endTime: '11:00',
    );

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await _createEvent(
      tester,
      title: '整理书架',
      startTime: '16:00',
      endTime: '17:00',
    );

    await tester.tap(find.text('14'));
    await tester.pumpAndSettle();

    final readingDeleteButton = find.byKey(_deleteKey('2026-7-14-10:00-读书'));
    await tester.ensureVisible(readingDeleteButton);
    await tester.pumpAndSettle();
    await tester.tap(readingDeleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await tester.pumpAndSettle();

    expect(find.text('读书'), findsNothing);
    expect(find.text('当天没有事项'), findsOneWidget);
    expect(find.byKey(const ValueKey('event-marker-2026-7-14')), findsNothing);

    final fifteenthDayAfterDelete = find.text('15');
    await tester.ensureVisible(fifteenthDayAfterDelete);
    await tester.pumpAndSettle();
    await tester.tap(fifteenthDayAfterDelete);
    await tester.pumpAndSettle();

    expect(find.text('整理书架'), findsOneWidget);
    expect(find.text('当天没有事项'), findsNothing);
    expect(
      find.byKey(const ValueKey('event-marker-2026-7-15')),
      findsOneWidget,
    );
  });

  testWidgets('persists created items after rebuilding the app', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore();

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    await _createEvent(
      tester,
      title: '写周报',
      startTime: '18:00',
      endTime: '18:30',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    expect(find.text('写周报'), findsOneWidget);
    expect(find.text('18:30'), findsOneWidget);
  });

  testWidgets('persists confirmed deletions after rebuilding the app', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore([
      CalendarEvent(
        date: DateTime(2026, 7, 13),
        time: '08:00',
        endTime: '08:30',
        title: '晨间整理',
        color: blueMarker,
        icon: Icons.event_note_rounded,
        iconBackground: const Color(0xffeef4ff),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    expect(find.text('晨间整理'), findsOneWidget);

    final deleteButton = find.byKey(_deleteKey('2026-7-13-08:00-晨间整理'));
    await tester.ensureVisible(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '删除'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    expect(find.text('晨间整理'), findsNothing);
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('does not let a late store load overwrite local edits', (
    tester,
  ) async {
    final store = _DelayedCalendarEventStore([
      CalendarEvent(
        date: DateTime(2026, 7, 13),
        time: '07:00',
        endTime: '07:30',
        title: '旧事项',
        color: blueMarker,
        icon: Icons.event_note_rounded,
        iconBackground: const Color(0xffeef4ff),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));

    await _createEvent(
      tester,
      title: '新事项',
      startTime: '18:00',
      endTime: '18:30',
    );

    store.completeLoad();
    await tester.pumpAndSettle();

    expect(find.text('新事项'), findsOneWidget);
    expect(find.text('旧事项'), findsNothing);
  });
}

Future<void> _createEvent(
  WidgetTester tester, {
  required String title,
  required String startTime,
  required String endTime,
}) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.widgetWithText(TextFormField, '标题'), title);
  await tester.enterText(find.widgetWithText(TextFormField, '开始时间'), startTime);
  await tester.enterText(find.widgetWithText(TextFormField, '结束时间'), endTime);
  await tester.tap(find.text('保存'));
  await tester.pumpAndSettle();
}

ValueKey<String> _deleteKey(String suffix) => ValueKey('delete-event-$suffix');

ValueKey<String> _scheduleDeleteKey(String suffix) {
  return ValueKey('delete-schedule-event-$suffix');
}

ValueKey<String> _todoToggleKey(DateTime createdAt) {
  return ValueKey('toggle-todo-${createdAt.toIso8601String()}');
}

ValueKey<String> _todoDeleteKey(DateTime createdAt) {
  return ValueKey('delete-todo-${createdAt.toIso8601String()}');
}

Future<void> _withSemantics(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final semanticsHandle = tester.ensureSemantics();
  try {
    await body();
  } finally {
    semanticsHandle.dispose();
  }
}

class _DelayedCalendarEventStore extends CalendarEventStore {
  _DelayedCalendarEventStore(this._loadedEvents);

  final List<CalendarEvent> _loadedEvents;
  final _loadCompleter = Completer<LocalCalendarData>();
  var savedEvents = <CalendarEvent>[];

  @override
  Future<LocalCalendarData> loadData() => _loadCompleter.future;

  @override
  Future<void> saveData(LocalCalendarData data) async {
    savedEvents = List.of(data.events);
  }

  @override
  Future<void> clearData() async {
    savedEvents = [];
  }

  void completeLoad() {
    _loadCompleter.complete(LocalCalendarData(events: _loadedEvents));
  }
}

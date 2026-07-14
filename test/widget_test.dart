import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';

void main() {
  testWidgets('renders the July 2026 calendar dashboard', (tester) async {
    await tester.pumpWidget(const CalendarApp());

    expect(find.text('2026年7月'), findsOneWidget);
    expect(find.text('今天'), findsOneWidget);
    expect(find.text('7月13日'), findsOneWidget);
    expect(find.text('农历五月廿九'), findsOneWidget);
    expect(find.text('当天没有事项'), findsOneWidget);
    expect(find.text('每一天，都是更好的自己。'), findsOneWidget);

    for (final label in ['日历', '日程', '待办', '我的']) {
      expect(find.text(label), findsOneWidget);
    }

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('month card exposes a five-week grid and selected day', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CalendarMonthCard())),
    );

    expect(find.byType(CalendarDayCell), findsNWidgets(35));
    expect(find.byKey(const ValueKey('selected-day-13')), findsOneWidget);
    expect(find.text('建党节'), findsOneWidget);
    expect(find.text('小暑'), findsOneWidget);
    expect(find.text('大暑'), findsOneWidget);
  });

  testWidgets('selected date drives the agenda list and empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CalendarHomeScreen(initialEvents: [todayEvents.first])),
    );

    expect(find.byKey(const ValueKey('selected-day-13')), findsOneWidget);
    expect(find.text('7月13日'), findsOneWidget);
    expect(find.text('团队晨会'), findsOneWidget);
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
    await tester.pumpWidget(const CalendarApp());

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
    await tester.pumpWidget(const CalendarApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('新增事项'), findsOneWidget);
    expect(find.text('请填写'), findsNWidgets(3));
    expect(find.text('当天没有事项'), findsOneWidget);
  });

  testWidgets('rejects items whose end time is not after the start time', (
    tester,
  ) async {
    await tester.pumpWidget(const CalendarApp());

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
    await tester.pumpWidget(const CalendarApp());

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
    await tester.pumpWidget(const CalendarApp());

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
    await tester.pumpWidget(const CalendarApp());

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

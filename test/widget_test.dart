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
}
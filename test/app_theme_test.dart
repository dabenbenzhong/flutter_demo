import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/models/todo_item.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/agenda_section.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_bottom_navigation.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

void main() {
  testWidgets('CalendarApp exposes application design tokens', (tester) async {
    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final theme = Theme.of(context);
    final tokens = theme.extension<AppThemeTokens>();

    expect(tokens, isNotNull);
    expect(tokens!.colors.background, isNot(tokens.colors.surface));
    expect(tokens.colors.primaryAction, isNot(tokens.colors.dangerAction));
    expect(tokens.colors.eventMarker, isNot(tokens.colors.statusSuccess));

    expect(
      tokens.text.pageTitle.fontSize,
      greaterThan(tokens.text.body.fontSize!),
    );
    expect(tokens.text.statistic.fontWeight, FontWeight.w900);
    expect(tokens.text.bottomNavigation.letterSpacing, 0);

    expect(tokens.spacing.xs, lessThan(tokens.spacing.sm));
    expect(tokens.spacing.sm, lessThan(tokens.spacing.md));
    expect(tokens.radii.card, lessThan(tokens.radii.pill));
    expect(tokens.shadows.card, isNotEmpty);

    expect(theme.scaffoldBackgroundColor, tokens.colors.background);
    expect(theme.inputDecorationTheme.filled, isTrue);
    expect(theme.filledButtonTheme.style, isNotNull);
    expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
    expect(theme.navigationBarTheme.labelTextStyle, isNotNull);
    expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
  });

  testWidgets('danger confirmations use danger action tokens', (tester) async {
    final store = MemoryCalendarEventStore([
      CalendarEvent(
        date: DateTime(2026, 7, 13),
        time: '10:00',
        endTime: '11:00',
        title: '读书',
        color: blueMarker,
        icon: Icons.event_note_rounded,
        iconBackground: const Color(0xffeef4ff),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;

    await tester.tap(
      find.byKey(const ValueKey('delete-event-2026-7-13-10:00-读书')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppConfirmDialog), findsOneWidget);

    final confirmButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '删除'),
    );

    expect(
      confirmButton.style?.backgroundColor?.resolve(<WidgetState>{}),
      tokens.colors.dangerAction,
    );
    expect(
      confirmButton.style?.foregroundColor?.resolve(<WidgetState>{}),
      tokens.colors.onDangerAction,
    );
  });

  testWidgets('shared components are used in real calendar paths', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('日程'));
    await tester.pumpAndSettle();

    expect(find.byType(AppPageContainer), findsOneWidget);
    expect(find.byType(AppPageTitle), findsOneWidget);
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('还没有事项'), findsOneWidget);

    final pageBackground = find
        .descendant(
          of: find.byType(AppPageContainer),
          matching: find.byType(DecoratedBox),
        )
        .first;
    final backgroundDecoration =
        tester.widget<DecoratedBox>(pageBackground).decoration as BoxDecoration;
    expect(
      tester.getSize(pageBackground),
      tester.getSize(find.byType(Scaffold)),
    );
    expect(backgroundDecoration.gradient, isA<LinearGradient>());

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('新增待办'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomFormShell), findsOneWidget);
    expect(find.text('新增待办项'), findsOneWidget);

    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();

    expect(find.byType(AppContentCard), findsOneWidget);
    expect(find.byType(AppStatRow), findsNWidgets(2));
  });

  testWidgets('app shell uses themed navigation and calendar-only action', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;
    final navigation = find.byType(CalendarBottomNavigation);

    expect(navigation, findsOneWidget);

    final navigationSurface = _decoratedBoxDecoration(
      tester,
      const ValueKey('calendar-bottom-navigation-surface'),
    );

    expect(
      navigationSurface.color,
      tokens.colors.surface.withValues(alpha: 0.96),
    );
    expect(navigationSurface.boxShadow, tokens.shadows.navigation);

    expect(
      tester
          .widget<NavigationBar>(
            find.descendant(
              of: navigation,
              matching: find.byType(NavigationBar),
            ),
          )
          .height,
      appBottomNavigationHeight,
    );
    expect(find.byType(AddEventButton), findsOneWidget);

    await tester.tap(_navigationLabel('日程'));
    await tester.pumpAndSettle();

    expect(find.text('按日期查看全部本地事项'), findsOneWidget);
    final labelStyle = Theme.of(context).navigationBarTheme.labelTextStyle!;
    expect(
      labelStyle.resolve({WidgetState.selected})?.color,
      tokens.colors.primaryAction,
    );
    expect(labelStyle.resolve({})?.color, tokens.colors.textSecondary);
    expect(
      _navigationIconColor(tester, Icons.format_list_bulleted_rounded),
      tokens.colors.primaryAction,
    );
    expect(
      _navigationIconColor(tester, Icons.calendar_month_rounded),
      tokens.colors.textSecondary,
    );
    expect(find.byType(AddEventButton), findsNothing);

    await tester.tap(_navigationLabel('日历'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('selected-day-13')), findsOneWidget);
    expect(find.byType(AddEventButton), findsOneWidget);
  });

  testWidgets('calendar primary action uses application tokens', (
    tester,
  ) async {
    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;
    final actionDecoration = _containerDecoration(
      tester,
      const ValueKey('calendar-add-event-button-surface'),
    );
    final actionIcon = tester.widget<Icon>(
      find.descendant(
        of: find.byType(AddEventButton),
        matching: find.byIcon(Icons.add),
      ),
    );

    expect(actionDecoration.shape, BoxShape.circle);
    expect(actionDecoration.color, tokens.colors.primaryAction);
    expect(actionDecoration.gradient, isNull);
    expect(actionDecoration.boxShadow, tokens.shadows.floating);
    expect(actionIcon.color, tokens.colors.onPrimaryAction);
  });

  testWidgets('calendar page areas use application design tokens', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore([
      CalendarEvent(
        date: DateTime(2026, 7, 13),
        time: '10:00',
        endTime: '11:00',
        title: '读书',
        notes: '整理摘抄',
        color: blueMarker,
        icon: Icons.event_note_rounded,
        iconBackground: const Color(0xffeef4ff),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;

    expect(
      find.descendant(
        of: find.byType(CalendarMonthCard),
        matching: find.byType(AppContentCard),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AgendaSection),
        matching: find.byType(AppContentCard),
      ),
      findsOneWidget,
    );

    final headerTitle = tester.widget<Text>(find.text('2026年7月'));
    expect(headerTitle.style?.fontSize, tokens.text.pageTitle.fontSize);
    expect(headerTitle.style?.fontWeight, tokens.text.pageTitle.fontWeight);
    expect(headerTitle.style?.color, tokens.colors.textPrimary);

    final previousButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_left_rounded),
    );
    expect(
      previousButton.style?.fixedSize?.resolve(<WidgetState>{}),
      const Size.square(44),
    );
    expect(
      previousButton.style?.backgroundColor?.resolve(<WidgetState>{}),
      tokens.colors.surface,
    );
    expect(
      previousButton.style?.foregroundColor?.resolve(<WidgetState>{}),
      tokens.colors.primaryAction,
    );
    expect(
      previousButton.style?.side?.resolve(<WidgetState>{})?.color,
      tokens.colors.border,
    );

    final selectedDecoration = _containerDecoration(
      tester,
      const ValueKey('selected-day-13'),
    );
    expect(selectedDecoration.color, tokens.colors.primaryAction);
    expect(selectedDecoration.gradient, isNull);
    expect(selectedDecoration.border?.top.color, tokens.colors.surface);

    final leadingCalendarCell = find.byType(CalendarDayCell).first;
    final leadingCellTexts = tester
        .widgetList<Text>(
          find.descendant(of: leadingCalendarCell, matching: find.byType(Text)),
        )
        .toList();

    expect(
      leadingCellTexts.first.style?.color,
      tokens.colors.textSecondary.withValues(alpha: 0.58),
    );
    expect(
      leadingCellTexts.last.style?.color,
      tokens.colors.textSecondary.withValues(alpha: 0.5),
    );

    final eventTitle = tester.widget<Text>(find.text('读书'));
    final eventDetail = tester.widget<Text>(find.text('11:00 · 整理摘抄'));

    expect(eventTitle.style?.fontSize, tokens.text.cardTitle.fontSize);
    expect(eventTitle.style?.fontWeight, tokens.text.cardTitle.fontWeight);
    expect(eventTitle.style?.color, tokens.colors.textPrimary);
    expect(eventDetail.style?.fontSize, tokens.text.helper.fontSize);
    expect(eventDetail.style?.color, tokens.colors.textSecondary);
  });

  testWidgets('schedule page list uses application design tokens', (
    tester,
  ) async {
    final store = MemoryCalendarEventStore([
      CalendarEvent(
        date: DateTime(2026, 7, 14),
        time: '09:00',
        endTime: '09:30',
        title: '晨间计划',
        color: blueMarker,
        icon: Icons.event_note_rounded,
        iconBackground: const Color(0xffeef4ff),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();
    await tester.tap(_navigationLabel('日程'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;

    expect(find.byType(AppPageContainer), findsOneWidget);
    expect(find.byType(AppPageTitle), findsOneWidget);
    expect(find.byType(AppContentCard), findsOneWidget);

    final dateTitle = tester.widget<Text>(find.text('2026年7月14日'));
    final eventTitle = tester.widget<Text>(find.text('晨间计划'));
    final eventTime = tester.widget<Text>(find.text('09:00 - 09:30'));
    final deleteButton = tester.widget<IconButton>(
      find.byKey(const ValueKey('delete-schedule-event-2026-7-14-09:00-晨间计划')),
    );

    expect(dateTitle.style?.fontSize, tokens.text.sectionTitle.fontSize);
    expect(dateTitle.style?.color, tokens.colors.textPrimary);
    expect(eventTitle.style?.fontSize, tokens.text.cardTitle.fontSize);
    expect(eventTitle.style?.color, tokens.colors.textPrimary);
    expect(eventTime.style?.fontSize, tokens.text.helper.fontSize);
    expect(eventTime.style?.color, tokens.colors.textSecondary);
    expect(deleteButton.color, tokens.colors.textSecondary);
  });

  testWidgets('todo page list uses application design tokens', (tester) async {
    final store = MemoryCalendarEventStore([], [
      TodoItem(title: '买菜', notes: '准备晚餐', createdAt: DateTime(2026, 7, 14, 9)),
      TodoItem(
        title: '归档票据',
        isCompleted: true,
        createdAt: DateTime(2026, 7, 14, 8),
      ),
    ]);

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();
    await tester.tap(_navigationLabel('待办'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;

    expect(find.byType(AppPageContainer), findsOneWidget);
    expect(find.byType(AppPageTitle), findsOneWidget);
    expect(find.byType(AppContentCard), findsNWidgets(2));

    final activeTitle = tester.widget<Text>(find.text('买菜'));
    final activeNotes = tester.widget<Text>(find.text('准备晚餐'));
    final completedTitle = tester.widget<Text>(find.text('归档票据'));
    final deleteButton = tester.widget<IconButton>(
      find.byKey(
        ValueKey('delete-todo-${DateTime(2026, 7, 14, 9).toIso8601String()}'),
      ),
    );

    expect(activeTitle.style?.fontSize, tokens.text.cardTitle.fontSize);
    expect(activeTitle.style?.color, tokens.colors.textPrimary);
    expect(activeNotes.style?.fontSize, tokens.text.helper.fontSize);
    expect(activeNotes.style?.color, tokens.colors.textSecondary);
    expect(completedTitle.style?.color, tokens.colors.statusCompleted);
    expect(completedTitle.style?.decoration, TextDecoration.lineThrough);
    expect(deleteButton.color, tokens.colors.textSecondary);
  });

  testWidgets('profile page uses statistic and danger action tokens', (
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
    await tester.tap(_navigationLabel('我的'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(CalendarHomeScreen));
    final tokens = context.appTheme;

    expect(find.byType(AppPageContainer), findsOneWidget);
    expect(find.byType(AppPageTitle), findsOneWidget);
    expect(find.byType(AppContentCard), findsOneWidget);
    expect(find.byType(AppStatRow), findsNWidgets(2));

    final appName = tester.widget<Text>(
      find.descendant(
        of: find.byType(AppContentCard),
        matching: find.text('日历'),
      ),
    );
    final description = tester.widget<Text>(
      find.text('本地日历专注记录事项和待办项，数据保存在当前设备内。'),
    );
    final clearButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '清空本地数据'),
    );

    expect(appName.style?.fontSize, tokens.text.sectionTitle.fontSize);
    expect(appName.style?.color, tokens.colors.textPrimary);
    expect(description.style?.fontSize, tokens.text.body.fontSize);
    expect(description.style?.color, tokens.colors.textSecondary);
    expect(
      clearButton.style?.backgroundColor?.resolve(<WidgetState>{}),
      tokens.colors.dangerAction,
    );
    expect(
      clearButton.style?.foregroundColor?.resolve(<WidgetState>{}),
      tokens.colors.onDangerAction,
    );
  });

  testWidgets('bottom navigation fits narrow mobile screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(CalendarApp());
    await tester.pumpAndSettle();

    final navigation = find.byType(CalendarBottomNavigation);
    final navigationRect = tester.getRect(navigation);

    expect(navigationRect.left, 0);
    expect(navigationRect.right, 320);
    expect(tester.getSize(find.byType(NavigationBar)).width, 320);

    const destinations = [
      (label: '日历', icon: Icons.calendar_month_rounded),
      (label: '日程', icon: Icons.format_list_bulleted_rounded),
      (label: '待办', icon: Icons.check_box_outlined),
      (label: '我的', icon: Icons.person_outline_rounded),
    ];
    final labelRects = <Rect>[];
    final iconRects = <Rect>[];

    for (final destination in destinations) {
      final labelRect = tester.getRect(_navigationLabel(destination.label));
      final iconRect = tester.getRect(_navigationIcon(destination.icon));

      labelRects.add(labelRect);
      iconRects.add(iconRect);

      expect(labelRect.left, greaterThanOrEqualTo(navigationRect.left));
      expect(labelRect.right, lessThanOrEqualTo(navigationRect.right));
      expect(iconRect.left, greaterThanOrEqualTo(navigationRect.left));
      expect(iconRect.right, lessThanOrEqualTo(navigationRect.right));
      expect(iconRect.size.width, greaterThan(0));
      expect(labelRect.overlaps(iconRect), isFalse);
    }

    for (var index = 1; index < destinations.length; index++) {
      expect(labelRects[index].overlaps(labelRects[index - 1]), isFalse);
      expect(iconRects[index].overlaps(iconRects[index - 1]), isFalse);
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('visual system pages avoid narrow mobile overflows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final store = MemoryCalendarEventStore(
      [
        CalendarEvent(
          date: DateTime(2026, 7, 14),
          time: '09:00',
          endTime: '09:30',
          title: '晨间计划',
          notes: '整理当天安排',
          color: blueMarker,
          icon: Icons.event_note_rounded,
          iconBackground: const Color(0xffeef4ff),
        ),
      ],
      [
        TodoItem(
          title: '买菜',
          notes: '准备晚餐',
          createdAt: DateTime(2026, 7, 14, 9),
        ),
      ],
    );

    await tester.pumpWidget(CalendarApp(eventStore: store));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    for (final label in ['日程', '待办', '我的', '日历']) {
      await tester.tap(_navigationLabel(label));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('bottom form shell keeps content above the bottom safe area', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(viewPadding: EdgeInsets.only(bottom: 28)),
          child: Scaffold(
            body: AppBottomFormShell(
              title: '新增待办项',
              onSubmit: () {},
              children: const [
                TextField(decoration: InputDecoration(labelText: '标题')),
              ],
            ),
          ),
        ),
      ),
    );

    final shellPadding =
        tester
                .widget<Padding>(
                  find
                      .descendant(
                        of: find.byType(AppBottomFormShell),
                        matching: find.byType(Padding),
                      )
                      .first,
                )
                .padding
            as EdgeInsets;

    expect(shellPadding.bottom, greaterThan(28));
  });
}

Finder _navigationLabel(String label) {
  return find
      .descendant(
        of: find.byType(CalendarBottomNavigation),
        matching: find.text(label),
      )
      .first;
}

Finder _navigationIcon(IconData icon) {
  return find
      .descendant(
        of: find.byType(CalendarBottomNavigation),
        matching: find.byIcon(icon),
      )
      .first;
}

Color? _navigationIconColor(WidgetTester tester, IconData icon) {
  return IconTheme.of(tester.element(_navigationIcon(icon))).color;
}

BoxDecoration _decoratedBoxDecoration(WidgetTester tester, Key key) {
  return tester.widget<DecoratedBox>(find.byKey(key)).decoration
      as BoxDecoration;
}

BoxDecoration _containerDecoration(WidgetTester tester, Key key) {
  return tester.widget<Container>(find.byKey(key)).decoration as BoxDecoration;
}

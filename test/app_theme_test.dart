import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
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

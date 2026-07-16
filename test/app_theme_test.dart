import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_demo/app.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_event_store.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/screens/calendar_home_screen.dart';
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
}

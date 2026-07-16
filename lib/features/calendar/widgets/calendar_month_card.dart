import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_date_utils.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({
    required this.visibleMonth,
    required this.selectedDate,
    this.onDateSelected,
    this.events = const [],
    super.key,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    final cells = _buildMonthCells(visibleMonth);

    return AppContentCard(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg - 1,
        tokens.spacing.md - 1,
        tokens.spacing.lg - 1,
        tokens.spacing.md - 1,
      ),
      child: Column(
        children: [
          const _WeekdayRow(),
          SizedBox(height: tokens.spacing.xs),
          Divider(height: 1, color: tokens.colors.border),
          SizedBox(height: tokens.spacing.xs),
          GridView.builder(
            itemCount: cells.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 47,
            ),
            itemBuilder: (context, index) {
              final cell = cells[index];
              final day = cell.day;
              final date = cell.date;
              final isSelected = isSameCalendarDate(date, selectedDate);
              final eventColors = day.isCurrentMonth
                  ? _eventColorsForDate(date)
                  : <Color>[];

              return CalendarDayCell(
                day: day.copyWith(
                  isSelected: isSelected,
                  showSelectionPointer: isSelected,
                  markerColors: eventColors.isEmpty
                      ? day.markerColors
                      : eventColors,
                  hasEvents: eventColors.isNotEmpty,
                  eventMarkerKey: eventColors.isNotEmpty
                      ? ValueKey(
                          'event-marker-${date.year}-${date.month}-${date.day}',
                        )
                      : null,
                ),
                eventSemanticsLabel: '${date.month}月${date.day}日有事项',
                onTap: day.isCurrentMonth
                    ? () => onDateSelected?.call(date)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  List<Color> _eventColorsForDate(DateTime date) {
    final colors = <Color>[];
    for (final event in events) {
      if (isSameCalendarDate(event.date, date) &&
          !colors.contains(event.color)) {
        colors.add(event.color);
      }
      if (colors.length == 3) {
        break;
      }
    }

    return colors;
  }
}

List<_MonthCell> _buildMonthCells(DateTime visibleMonth) {
  final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
  final daysInMonth = DateTime(
    visibleMonth.year,
    visibleMonth.month + 1,
    0,
  ).day;
  final leadingDays = firstDay.weekday - DateTime.monday;
  final minimumCellCount = leadingDays + daysInMonth <= 35 ? 35 : 42;

  return [
    for (var index = 0; index < minimumCellCount; index++)
      _monthCellForDate(
        DateTime(
          visibleMonth.year,
          visibleMonth.month,
          index - leadingDays + 1,
        ),
        visibleMonth,
      ),
  ];
}

_MonthCell _monthCellForDate(DateTime date, DateTime visibleMonth) {
  final isCurrentMonth =
      date.year == visibleMonth.year && date.month == visibleMonth.month;
  final demoDay = _demoDayForDate(date, isCurrentMonth);

  return _MonthCell(
    date: date,
    day: CalendarDay(
      day: date.day,
      lunarText: demoDay?.lunarText ?? '',
      label: demoDay?.label,
      labelColor: demoDay?.labelColor,
      markerColors: demoDay?.markerColors ?? const [],
      isCurrentMonth: isCurrentMonth,
    ),
  );
}

CalendarDay? _demoDayForDate(DateTime date, bool isCurrentMonth) {
  if (!isCurrentMonth || date.year != 2026 || date.month != 7) {
    return null;
  }

  for (final day in calendarDays) {
    if (day.isCurrentMonth && day.day == date.day) {
      return day;
    }
  }

  return null;
}

class _MonthCell {
  const _MonthCell({required this.date, required this.day});

  final DateTime date;
  final CalendarDay day;
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Row(
      children: [
        for (final weekday in weekdays)
          Expanded(
            child: Text(
              weekday,
              textAlign: TextAlign.center,
              style: tokens.text.body.copyWith(
                color: tokens.colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

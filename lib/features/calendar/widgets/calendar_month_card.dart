import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/utils/calendar_date_utils.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';

class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({
    this.selectedDate,
    this.onDateSelected,
    this.events = const [],
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedDate = selectedDate ?? DateTime(2026, 7, 13);

    return AppGlassCard(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Column(
        children: [
          const _WeekdayRow(),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: const Color(0xffd9cfc3).withValues(alpha: 0.72),
          ),
          const SizedBox(height: 17),
          GridView.builder(
            itemCount: calendarDays.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 76,
            ),
            itemBuilder: (context, index) {
              final day = calendarDays[index];
              final date = _dateForDay(day, index);
              final isSelected = isSameCalendarDate(
                date,
                effectiveSelectedDate,
              );
              final eventColors = _eventColorsForDate(date);

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
      if (isSameCalendarDate(event.date, date) && !colors.contains(event.color)) {
        colors.add(event.color);
      }
      if (colors.length == 3) {
        break;
      }
    }

    return colors;
  }
}

DateTime _dateForDay(CalendarDay day, int index) {
  if (day.isCurrentMonth) {
    return DateTime(2026, 7, day.day);
  }

  return index < 7 ? DateTime(2026, 6, day.day) : DateTime(2026, 8, day.day);
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final weekday in weekdays)
          Expanded(
            child: Text(
              weekday,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: warmBrown,
                fontSize: 19,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ),
      ],
    );
  }
}

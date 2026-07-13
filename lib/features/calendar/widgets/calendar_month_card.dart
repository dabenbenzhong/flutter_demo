import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_day_cell.dart';

class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              return CalendarDayCell(day: calendarDays[index]);
            },
          ),
        ],
      ),
    );
  }
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

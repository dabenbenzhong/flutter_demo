import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({
    required this.selectedDate,
    required this.events,
    required this.onDeleteEvent,
    super.key,
  });

  final DateTime selectedDate;
  final List<CalendarEvent> events;
  final ValueChanged<CalendarEvent> onDeleteEvent;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AgendaHeader(selectedDate: selectedDate),
          const SizedBox(height: 16),
          if (events.isEmpty)
            const _EmptyAgendaState()
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TimeColumn(events: events),
                  const SizedBox(width: 10),
                  _TimelineRail(events: events),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        for (final event in events) ...[
                          AgendaEventTile(
                            event: event,
                            onDelete: () => onDeleteEvent(event),
                          ),
                          if (event != events.last) const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AgendaEventTile extends StatelessWidget {
  const AgendaEventTile({
    required this.event,
    required this.onDelete,
    super.key,
  });

  final CalendarEvent event;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff4c2d18).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: double.infinity,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: warmBrown,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: warmBrown.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _EventIcon(event: event),
          IconButton(
            key: ValueKey(
              'delete-event-${event.date.year}-${event.date.month}-${event.date.day}-${event.time}-${event.title}',
            ),
            tooltip: '删除事项',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: warmBrown.withValues(alpha: 0.62),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      '${selectedDate.month}月${selectedDate.day}日',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: warmBrown,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      _weekdayText(selectedDate),
                      style: TextStyle(
                        color: warmBrown.withValues(alpha: 0.86),
                        fontSize: 14,
                        height: 1,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                _lunarDescription(selectedDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: warmBrown.withValues(alpha: 0.86),
                  fontSize: 14,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '33日后 周例会',
                style: TextStyle(
                  color: warmBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.chevron_right_rounded, color: warmBrown, size: 22),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.events});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final event in events)
            SizedBox(
              height: 74,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    event.time,
                    style: const TextStyle(
                      color: warmBrown,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.events});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 24,
            bottom: 24,
            child: Container(width: 2, color: const Color(0xffd4cbc1)),
          ),
          for (var index = 0; index < events.length; index++)
            Positioned(
              top: 18 + (index * 84),
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: events[index].color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyAgendaState extends StatelessWidget {
  const _EmptyAgendaState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
      ),
      child: Text(
        '当天没有事项',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: warmBrown.withValues(alpha: 0.68),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

String _weekdayText(DateTime date) {
  const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  return weekdays[date.weekday - 1];
}

String _lunarDescription(DateTime date) {
  if (date.year == 2026 && date.month == 7 && date.day == 13) {
    return '农历五月廿九';
  }

  if (date.year == 2026 && date.month == 7) {
    for (final day in calendarDays) {
      if (day.isCurrentMonth && day.day == date.day) {
        return '农历${day.lunarText}';
      }
    }
  }

  return '农历';
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: event.iconBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: event.color.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(event.icon, color: event.color, size: 25),
    );
  }
}

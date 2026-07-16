import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

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
    final tokens = context.appTheme;

    return AppContentCard(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        tokens.spacing.lg - 2,
        tokens.spacing.md,
        tokens.spacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AgendaHeader(selectedDate: selectedDate),
          SizedBox(height: tokens.spacing.md),
          if (events.isEmpty)
            const _EmptyAgendaState()
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TimeColumn(events: events),
                  SizedBox(width: tokens.spacing.xs),
                  _TimelineRail(events: events),
                  SizedBox(width: tokens.spacing.sm),
                  Expanded(
                    child: Column(
                      children: [
                        for (final event in events) ...[
                          AgendaEventTile(
                            event: event,
                            onDelete: () => onDeleteEvent(event),
                          ),
                          if (event != events.last)
                            SizedBox(height: tokens.spacing.xs),
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
    final tokens = context.appTheme;

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.textPrimary.withValues(alpha: 0.08),
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
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                bottomLeft: const Radius.circular(16),
              ),
            ),
          ),
          SizedBox(width: tokens.spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.cardTitle.copyWith(
                    color: tokens.colors.textPrimary,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: tokens.spacing.xxs + 2),
                Text(
                  event.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.helper.copyWith(
                    color: tokens.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: tokens.spacing.xs),
          _EventIcon(event: event),
          IconButton(
            key: ValueKey(
              'delete-event-${event.date.year}-${event.date.month}-${event.date.day}-${event.time}-${event.title}',
            ),
            tooltip: '删除事项',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: tokens.colors.textSecondary,
          ),
          SizedBox(width: tokens.spacing.xxs),
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
    final tokens = context.appTheme;

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
                      style: tokens.text.sectionTitle.copyWith(
                        color: tokens.colors.textPrimary,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      _weekdayText(selectedDate),
                      style: tokens.text.helper.copyWith(
                        color: tokens.colors.textSecondary,
                        height: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: tokens.spacing.xs),
              Text(
                _lunarDescription(selectedDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.helper.copyWith(
                  color: tokens.colors.textSecondary,
                  height: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: tokens.spacing.xs),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '33日后 周例会',
                style: tokens.text.helper.copyWith(
                  color: tokens.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: tokens.spacing.xxs),
              Icon(
                Icons.chevron_right_rounded,
                color: tokens.colors.primaryAction,
                size: 22,
              ),
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
    final tokens = context.appTheme;

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
                    style: tokens.text.body.copyWith(
                      color: tokens.colors.textPrimary,
                      fontWeight: FontWeight.w700,
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
    final tokens = context.appTheme;

    return SizedBox(
      width: 15,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 24,
            bottom: 24,
            child: Container(width: 2, color: tokens.colors.border),
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
                  border: Border.all(color: tokens.colors.surface, width: 2),
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
    final tokens = context.appTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: tokens.spacing.xl),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceMuted.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(tokens.radii.control),
        border: Border.all(color: tokens.colors.border),
      ),
      child: Text(
        '当天没有事项',
        textAlign: TextAlign.center,
        style: tokens.text.body.copyWith(
          color: tokens.colors.textSecondary,
          fontWeight: FontWeight.w700,
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
    final tokens = context.appTheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: event.iconBackground,
        borderRadius: BorderRadius.circular(tokens.radii.control),
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

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';
import 'package:my_flutter_demo/features/calendar/widgets/app_glass_card.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.fromLTRB(24, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AgendaHeader(),
          const SizedBox(height: 22),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TimeColumn(),
                const SizedBox(width: 13),
                const _TimelineRail(),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    children: [
                      for (final event in todayEvents) ...[
                        AgendaEventTile(event: event),
                        if (event != todayEvents.last)
                          const SizedBox(height: 14),
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
  const AgendaEventTile({required this.event, super.key});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
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
            width: 6,
            height: double.infinity,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 24),
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
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: warmBrown.withValues(alpha: 0.7),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _EventIcon(event: event),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '7月13日',
          style: TextStyle(
            color: warmBrown,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '周一',
                style: TextStyle(
                  color: warmBrown.withValues(alpha: 0.86),
                  fontSize: 16,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '农历五月廿九',
                style: TextStyle(
                  color: warmBrown.withValues(alpha: 0.86),
                  fontSize: 16,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '33日后 周例会',
                style: TextStyle(
                  color: warmBrown,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: warmBrown, size: 26),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final event in todayEvents)
            SizedBox(
              height: 86,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    event.time,
                    style: const TextStyle(
                      color: warmBrown,
                      fontSize: 18,
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
  const _TimelineRail();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 28,
            bottom: 28,
            child: Container(width: 2, color: const Color(0xffd4cbc1)),
          ),
          for (var index = 0; index < todayEvents.length; index++)
            Positioned(
              top: 21 + (index * 100),
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: todayEvents[index].color,
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

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: event.iconBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: event.color.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(event.icon, color: event.color, size: 31),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({required this.day, this.onTap, super.key});

  final CalendarDay day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = day.isCurrentMonth
        ? Colors.black
        : const Color(0xffaaa49e);
    final subtitleColor = day.isCurrentMonth
        ? warmBrown.withValues(alpha: 0.82)
        : const Color(0xffaaa49e);

    final cell = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 47,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            if (day.showSelectionPointer)
              const Positioned(
                left: -6,
                top: 13,
                child: Icon(Icons.play_arrow_rounded, color: caramel, size: 15),
              ),
            if (day.isSelected)
              Positioned(
                top: 4,
                child: Container(
                  key: ValueKey('selected-day-${day.day}'),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffd99a52), Color(0xffb66f2e)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: caramel.withValues(alpha: 0.42),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 2,
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color: day.isSelected ? Colors.white : textColor,
                    fontSize: day.isSelected ? 18 : 17,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  day.label ?? day.lunarText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: day.isSelected
                        ? Colors.white
                        : day.labelColor ?? subtitleColor,
                    fontSize: 10.5,
                    height: 1.05,
                    fontWeight: day.label == null
                        ? FontWeight.w500
                        : FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                _MarkerDots(
                  colors: day.markerColors,
                  eventMarkerKey: day.eventMarkerKey,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!day.hasEvents || !day.isCurrentMonth) {
      return cell;
    }

    return Semantics(label: '7月${day.day}日有事项', child: cell);
  }
}

class _MarkerDots extends StatelessWidget {
  const _MarkerDots({required this.colors, this.eventMarkerKey});

  final List<Color> colors;
  final Key? eventMarkerKey;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox(height: 5);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final color in colors)
          Container(
            key: color == colors.first ? eventMarkerKey : null,
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
      ],
    );
  }
}

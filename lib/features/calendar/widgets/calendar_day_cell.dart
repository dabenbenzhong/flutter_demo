import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({required this.day, super.key});

  final CalendarDay day;

  @override
  Widget build(BuildContext context) {
    final textColor = day.isCurrentMonth
        ? Colors.black
        : const Color(0xffaaa49e);
    final subtitleColor = day.isCurrentMonth
        ? warmBrown.withValues(alpha: 0.82)
        : const Color(0xffaaa49e);

    return SizedBox(
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (day.showSelectionPointer)
            const Positioned(
              left: -6,
              top: 24,
              child: Icon(Icons.play_arrow_rounded, color: caramel, size: 18),
            ),
          if (day.isSelected)
            Positioned(
              top: 8,
              child: Container(
                key: ValueKey('selected-day-${day.day}'),
                width: 56,
                height: 56,
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
                      blurRadius: 18,
                      offset: const Offset(0, 8),
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
              const SizedBox(height: 9),
              Text(
                '${day.day}',
                style: TextStyle(
                  color: day.isSelected ? Colors.white : textColor,
                  fontSize: day.isSelected ? 25 : 24,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                day.label ?? day.lunarText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: day.isSelected
                      ? Colors.white
                      : day.labelColor ?? subtitleColor,
                  fontSize: 15,
                  height: 1.05,
                  fontWeight: day.label == null
                      ? FontWeight.w500
                      : FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 8),
              _MarkerDots(colors: day.markerColors),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarkerDots extends StatelessWidget {
  const _MarkerDots({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox(height: 6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final color in colors)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
      ],
    );
  }
}

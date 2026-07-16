import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.day,
    this.eventSemanticsLabel,
    this.onTap,
    super.key,
  });

  final CalendarDay day;
  final String? eventSemanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    final inactiveTextColor = tokens.colors.textSecondary.withValues(
      alpha: 0.58,
    );
    final inactiveSubtitleColor = tokens.colors.textSecondary.withValues(
      alpha: 0.5,
    );
    final textColor = day.isCurrentMonth
        ? tokens.colors.textPrimary
        : inactiveTextColor;
    final subtitleColor = day.isCurrentMonth
        ? tokens.colors.textSecondary
        : inactiveSubtitleColor;
    final selectedTextColor = tokens.colors.onPrimaryAction;

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
              Positioned(
                left: -6,
                top: 18,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: tokens.colors.primaryAction,
                    borderRadius: BorderRadius.circular(tokens.radii.xs - 1),
                  ),
                ),
              ),
            if (day.isSelected)
              Positioned(
                top: 4,
                child: Container(
                  key: ValueKey('selected-day-${day.day}'),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.colors.primaryAction,
                    boxShadow: tokens.shadows.floating,
                    border: Border.all(color: tokens.colors.surface, width: 2),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  '${day.day}',
                  style: tokens.text.cardTitle.copyWith(
                    color: day.isSelected ? selectedTextColor : textColor,
                    height: 1.05,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  day.label ?? day.lunarText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.helper.copyWith(
                    color: day.isSelected
                        ? selectedTextColor
                        : day.labelColor ?? subtitleColor,
                    fontSize: 11,
                    height: 1.05,
                    fontWeight: day.label == null
                        ? FontWeight.w500
                        : FontWeight.w700,
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

    return Semantics(
      label: eventSemanticsLabel ?? '${day.day}日有事项',
      child: cell,
    );
  }
}

class _MarkerDots extends StatelessWidget {
  const _MarkerDots({required this.colors, this.eventMarkerKey});

  final List<Color> colors;
  final Key? eventMarkerKey;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    if (colors.isEmpty) {
      return SizedBox(height: tokens.spacing.xs - 3);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final color in colors)
          Container(
            key: color == colors.first ? eventMarkerKey : null,
            width: 5,
            height: 5,
            margin: EdgeInsets.symmetric(horizontal: tokens.spacing.xxs / 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
      ],
    );
  }
}

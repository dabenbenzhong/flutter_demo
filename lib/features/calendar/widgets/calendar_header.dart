import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.visibleMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    super.key,
  });

  final DateTime visibleMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 390;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, isCompact ? 12 : 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _MonthIconButton(
                tooltip: '上个月',
                icon: Icons.chevron_left_rounded,
                isCompact: isCompact,
                onPressed: onPreviousMonth,
              ),
              SizedBox(width: isCompact ? 6 : 8),
              Expanded(
                child: Text(
                  '${visibleMonth.year}年${visibleMonth.month}月',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: warmBrown,
                    fontSize: isCompact ? 30 : 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              SizedBox(width: isCompact ? 6 : 8),
              _MonthIconButton(
                tooltip: '下个月',
                icon: Icons.chevron_right_rounded,
                isCompact: isCompact,
                onPressed: onNextMonth,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MonthIconButton extends StatelessWidget {
  const _MonthIconButton({
    required this.tooltip,
    required this.icon,
    required this.isCompact,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool isCompact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: Size.square(isCompact ? 40 : 44),
        backgroundColor: Colors.white.withValues(alpha: 0.62),
        foregroundColor: warmBrown,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.78)),
        shape: const CircleBorder(),
      ),
      icon: Icon(icon, size: isCompact ? 24 : 26),
    );
  }
}

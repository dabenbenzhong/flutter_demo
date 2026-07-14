import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/data/calendar_demo_data.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

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
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '2026年7月',
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: warmBrown,
                              fontSize: isCompact ? 30 : 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    SizedBox(width: isCompact ? 4 : 8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: warmBrown,
                      size: isCompact ? 24 : 28,
                    ),
                  ],
                ),
              ),
              TodayButton(isCompact: isCompact),
              SizedBox(width: isCompact ? 7 : 10),
              SearchButton(isCompact: isCompact),
            ],
          ),
        );
      },
    );
  }
}

class TodayButton extends StatelessWidget {
  const TodayButton({required this.isCompact, super.key});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isCompact ? 38 : 40,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 15 : 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Text(
        '今天',
        style: TextStyle(
          color: warmBrown,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({required this.isCompact, super.key});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 44 : 48,
      height: isCompact ? 44 : 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
      ),
      child: Icon(Icons.search, color: warmBrown, size: isCompact ? 24 : 26),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

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
    final tokens = context.appTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.md,
        tokens.spacing.sm,
        tokens.spacing.md,
        tokens.spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _MonthIconButton(
            tooltip: '上个月',
            icon: Icons.chevron_left_rounded,
            onPressed: onPreviousMonth,
          ),
          SizedBox(width: tokens.spacing.xs),
          Expanded(
            child: Text(
              '${visibleMonth.year}年${visibleMonth.month}月',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: tokens.text.pageTitle.copyWith(
                color: tokens.colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: tokens.spacing.xs),
          _MonthIconButton(
            tooltip: '下个月',
            icon: Icons.chevron_right_rounded,
            onPressed: onNextMonth,
          ),
        ],
      ),
    );
  }
}

class _MonthIconButton extends StatelessWidget {
  const _MonthIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: const Size.square(44),
        backgroundColor: tokens.colors.surface,
        foregroundColor: tokens.colors.primaryAction,
        side: BorderSide(color: tokens.colors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radii.control),
        ),
      ),
      icon: Icon(icon, size: 24),
    );
  }
}

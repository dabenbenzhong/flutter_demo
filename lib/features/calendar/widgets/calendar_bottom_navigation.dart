import 'package:flutter/material.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class CalendarBottomNavigation extends StatelessWidget {
  const CalendarBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    const items = [
      _NavigationItemData(Icons.calendar_month_rounded, '日历'),
      _NavigationItemData(Icons.format_list_bulleted_rounded, '日程'),
      _NavigationItemData(Icons.check_box_outlined, '待办'),
      _NavigationItemData(Icons.person_outline_rounded, '我的'),
    ];

    return DecoratedBox(
      key: const ValueKey('calendar-bottom-navigation-surface'),
      decoration: BoxDecoration(
        color: tokens.colors.surface.withValues(alpha: 0.86),
        boxShadow: tokens.shadows.navigation,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: appBottomNavigationHeight,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: appPageMaxWidth),
                child: Row(
                  children: [
                    for (var index = 0; index < items.length; index++)
                      Expanded(
                        child: _NavigationItem(
                          data: items[index],
                          isSelected: selectedIndex == index,
                          onTap: () => onSelected(index),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItemData {
  const _NavigationItemData(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _NavigationItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;
    final color = isSelected
        ? tokens.colors.primaryAction
        : tokens.colors.textSecondary.withValues(alpha: 0.78);

    return InkResponse(
      onTap: onTap,
      radius: 34,
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: EdgeInsets.only(top: tokens.spacing.xs + 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, size: 27, color: color),
              SizedBox(height: tokens.spacing.xxs - 1),
              Text(
                data.label,
                style: tokens.text.bottomNavigation.copyWith(
                  color: color,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

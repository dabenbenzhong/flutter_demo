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
        color: tokens.colors.surface.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: tokens.colors.border)),
        boxShadow: tokens.shadows.navigation,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: appBottomNavigationHeight,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: appPageMaxWidth),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelected,
                height: appBottomNavigationHeight,
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  for (final item in items)
                    NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon),
                      label: item.label,
                    ),
                ],
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

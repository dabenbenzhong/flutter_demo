import 'package:flutter/material.dart';
import 'package:my_flutter_demo/ui/components/app_components.dart';
import 'package:my_flutter_demo/ui/theme/app_theme.dart';

class AddEventButton extends StatelessWidget {
  const AddEventButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTheme;

    return Tooltip(
      message: '新增事项',
      child: Semantics(
        button: true,
        label: '新增事项',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Container(
            key: const ValueKey('calendar-add-event-button-surface'),
            width: appFloatingActionButtonSize,
            height: appFloatingActionButtonSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffdfa157), Color(0xffb86f30)],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 1.33,
              ),
              boxShadow: tokens.shadows.floating,
            ),
            child: Icon(
              Icons.add,
              color: tokens.colors.onPrimaryAction,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}

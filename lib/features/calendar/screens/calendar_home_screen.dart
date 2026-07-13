import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/widgets/add_event_button.dart';
import 'package:my_flutter_demo/features/calendar/widgets/agenda_section.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_bottom_navigation.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_header.dart';
import 'package:my_flutter_demo/features/calendar/widgets/calendar_month_card.dart';
import 'package:my_flutter_demo/features/calendar/widgets/inspiration_banner.dart';

class CalendarHomeScreen extends StatelessWidget {
  const CalendarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const _CalendarBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 112),
            child: Column(
              children: [
                CalendarHeader(),
                CalendarMonthCard(),
                SizedBox(height: 20),
                AgendaSection(),
                SizedBox(height: 20),
                InspirationBanner(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const AddEventButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CalendarBottomNavigation(),
    );
  }
}

class _CalendarBackground extends StatelessWidget {
  const _CalendarBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xfffff1df), Color(0xfff8eadc), Color(0xfff3e6dc)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _SoftBackgroundPainter()),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _SoftBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);

    glowPaint.color = Colors.white.withValues(alpha: 0.72);
    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.18),
      116,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.34),
      96,
      glowPaint,
    );

    glowPaint.color = const Color(0xffd8a467).withValues(alpha: 0.18);
    canvas.drawCircle(
      Offset(size.width * 0.66, size.height * 0.12),
      110,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.8),
      120,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

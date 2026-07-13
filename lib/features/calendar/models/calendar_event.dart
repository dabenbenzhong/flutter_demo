import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.time,
    required this.title,
    required this.detail,
    required this.color,
    required this.icon,
    required this.iconBackground,
  });

  final String time;
  final String title;
  final String detail;
  final Color color;
  final IconData icon;
  final Color iconBackground;
}

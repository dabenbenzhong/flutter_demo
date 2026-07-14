import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.date,
    required this.time,
    required this.endTime,
    required this.title,
    this.notes = '',
    required this.color,
    required this.icon,
    required this.iconBackground,
  });

  final DateTime date;
  final String time;
  final String endTime;
  final String title;
  final String notes;
  final Color color;
  final IconData icon;
  final Color iconBackground;

  String get detail {
    if (notes.isEmpty) {
      return endTime;
    }

    return '$endTime · $notes';
  }
}

import 'package:flutter/material.dart';

class CalendarDay {
  const CalendarDay({
    required this.day,
    required this.lunarText,
    this.label,
    this.labelColor,
    this.markerColors = const [],
    this.isCurrentMonth = true,
    this.isSelected = false,
    this.showSelectionPointer = false,
    this.hasEvents = false,
    this.eventMarkerKey,
  });

  final int day;
  final String lunarText;
  final String? label;
  final Color? labelColor;
  final List<Color> markerColors;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool showSelectionPointer;
  final bool hasEvents;
  final Key? eventMarkerKey;

  CalendarDay copyWith({
    List<Color>? markerColors,
    bool? isSelected,
    bool? showSelectionPointer,
    bool? hasEvents,
    Key? eventMarkerKey,
  }) {
    return CalendarDay(
      day: day,
      lunarText: lunarText,
      label: label,
      labelColor: labelColor,
      markerColors: markerColors ?? this.markerColors,
      isCurrentMonth: isCurrentMonth,
      isSelected: isSelected ?? this.isSelected,
      showSelectionPointer: showSelectionPointer ?? this.showSelectionPointer,
      hasEvents: hasEvents ?? this.hasEvents,
      eventMarkerKey: eventMarkerKey ?? this.eventMarkerKey,
    );
  }
}

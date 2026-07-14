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
  });

  final int day;
  final String lunarText;
  final String? label;
  final Color? labelColor;
  final List<Color> markerColors;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool showSelectionPointer;

  CalendarDay copyWith({
    List<Color>? markerColors,
    bool? isSelected,
    bool? showSelectionPointer,
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
    );
  }
}

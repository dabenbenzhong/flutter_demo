import 'package:flutter/material.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_day.dart';
import 'package:my_flutter_demo/features/calendar/models/calendar_event.dart';

const warmBrown = Color(0xff2e1608);
const caramel = Color(0xffc9823a);
const amberMarker = Color(0xfff09a10);
const blueMarker = Color(0xff2d7bf0);
const greenMarker = Color(0xff35bd7b);
const purpleMarker = Color(0xff835be9);

const weekdays = ['一', '二', '三', '四', '五', '六', '日'];

const calendarDays = <CalendarDay>[
  CalendarDay(day: 29, lunarText: '初六', isCurrentMonth: false),
  CalendarDay(day: 30, lunarText: '初七', isCurrentMonth: false),
  CalendarDay(day: 1, lunarText: '建党节', label: '建党节', labelColor: Colors.red),
  CalendarDay(day: 2, lunarText: '初八'),
  CalendarDay(day: 3, lunarText: '初九'),
  CalendarDay(day: 4, lunarText: '初十'),
  CalendarDay(day: 5, lunarText: '十一'),
  CalendarDay(day: 6, lunarText: '十二'),
  CalendarDay(
    day: 7,
    lunarText: '小暑',
    label: '小暑',
    labelColor: blueMarker,
    markerColors: [blueMarker],
  ),
  CalendarDay(day: 8, lunarText: '十四'),
  CalendarDay(day: 9, lunarText: '十五', markerColors: [amberMarker]),
  CalendarDay(day: 10, lunarText: '十六', markerColors: [amberMarker]),
  CalendarDay(day: 11, lunarText: '十七'),
  CalendarDay(day: 12, lunarText: '十八'),
  CalendarDay(
    day: 13,
    lunarText: '一',
    markerColors: [amberMarker, amberMarker],
    isSelected: true,
    showSelectionPointer: true,
  ),
  CalendarDay(day: 14, lunarText: '三十'),
  CalendarDay(day: 15, lunarText: '初一'),
  CalendarDay(day: 16, lunarText: '初二', markerColors: [blueMarker]),
  CalendarDay(day: 17, lunarText: '初三'),
  CalendarDay(day: 18, lunarText: '初四'),
  CalendarDay(day: 19, lunarText: '初五'),
  CalendarDay(day: 20, lunarText: '初六'),
  CalendarDay(day: 21, lunarText: '初七'),
  CalendarDay(
    day: 22,
    lunarText: '大暑',
    label: '大暑',
    labelColor: blueMarker,
    markerColors: [blueMarker],
  ),
  CalendarDay(day: 23, lunarText: '初九', markerColors: [greenMarker]),
  CalendarDay(day: 24, lunarText: '三十', markerColors: [blueMarker]),
  CalendarDay(day: 25, lunarText: '七月'),
  CalendarDay(day: 26, lunarText: '初二'),
  CalendarDay(day: 27, lunarText: '初三'),
  CalendarDay(day: 28, lunarText: '初四'),
  CalendarDay(day: 29, lunarText: '初五'),
  CalendarDay(day: 30, lunarText: '初六'),
  CalendarDay(day: 31, lunarText: '初七'),
  CalendarDay(day: 1, lunarText: '初八', isCurrentMonth: false),
  CalendarDay(day: 2, lunarText: '初九', isCurrentMonth: false),
];

final todayEvents = <CalendarEvent>[
  CalendarEvent(
    date: DateTime(2026, 7, 13),
    time: '09:00',
    endTime: '09:30',
    title: '团队晨会',
    notes: '会议室 A · 30分钟',
    color: blueMarker,
    icon: Icons.groups_rounded,
    iconBackground: Color(0xffeef4ff),
  ),
  CalendarEvent(
    date: DateTime(2026, 7, 13),
    time: '14:00',
    endTime: '15:00',
    title: '产品评审',
    notes: '线上会议 · 60分钟',
    color: purpleMarker,
    icon: Icons.trending_up_rounded,
    iconBackground: Color(0xfff5edff),
  ),
  CalendarEvent(
    date: DateTime(2026, 7, 13),
    time: '19:30',
    endTime: '20:30',
    title: '健身',
    notes: '万科健身 · 60分钟',
    color: greenMarker,
    icon: Icons.fitness_center_rounded,
    iconBackground: Color(0xffeaf8ef),
  ),
];

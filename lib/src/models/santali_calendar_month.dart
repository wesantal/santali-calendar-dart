import 'package:santali_calendar/src/constants/weeks.dart';
import 'package:santali_calendar/src/models/santali_calendar_day.dart';
import 'package:santali_calendar/src/models/santali_month.dart';

class SantaliCalendarMonth extends SantaliMonth {
  final Map<SantaliWeekDay, List<SantaliCalendarDay?>> calendar;

  const SantaliCalendarMonth({
    required super.days,
    required super.name,
    required super.english,
    required super.startDate,
    required super.endDate,
    required this.calendar,
  });
}
